class CostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_cost, only: [:show, :edit, :update, :destroy]

  # GET /costs
  # GET /costs.json
  def index
    @tab = :admins
    @costs = Cost.all
  end

  # GET /costs/1
  # GET /costs/1.json
  def show
  end

  # GET /costs/new
  def new
    @cost = Cost.new
  end

  # GET /costs/1/edit
  def edit
  end

  # POST /costs
  # POST /costs.json
  def create
    @cost = Cost.new(cost_params)

    @cost.admin_id = current_admin.id

    @cost.save

    @codevals = Codeval.all

    @codevals.each do |codeval|
      value = Value.new
      value.codeval = codeval
      value.cost = @cost
      if @cost.base == nil
        value.value = 0
      else
        value.value = codeval.values.find_by_cost_id(@cost.base.to_i).value * (1 + (@cost.factor.to_f / 100))
      end
      value.description = @cost.description
      value.admin_id = current_admin.id
      value.save
    end

    redirect_to @cost, notice: 'Tabla de costos exitosamente creada.'

  end

  # PATCH/PUT /costs/1
  # PATCH/PUT /costs/1.json
  def update

    if cost_params[:base] != ""
      @cost.values.each do |value|
        value.update(value: (Value.where(cost_id: cost_params[:base], codeval_id: value.codeval_id).first.value * (1 + (cost_params[:factor].to_f / 100))), admin_id: current_admin.id, description: cost_params[:description])
      end
      
    else
      if @cost.values.count == 0  #Solo pone en 0 los valores si NO hay ya unos costos/values
        @cost.values.each do |value|
          value.update(value: 0, admin_id: current_admin.id, description: cost_params[:description])
        end
      end
      
    end
    
    Rate.all.each do |rate|
      if rate.cost_id == params[:id].to_i
        rate.factors.each do |factor|
          factor.update(price: Value.where(cost_id: params[:id].to_i, codeval_id: factor.codeval_id).first.value * (1 + (factor.factor / 100)), description: factor.description)
        end
      end
    end

    if @cost.update(cost_params)
      redirect_to @cost, notice: 'Tabla de costos y sus tarifas asociadas exitosamente actualizadas.'
    else
      render :edit
    end
    
  end

  # DELETE /costs/1
  # DELETE /costs/1.json
  def destroy
    @cost.destroy
    redirect_to costs_url, notice: 'Tabla de costo exitosamente borrada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost
      @cost = Cost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_params
      params.require(:cost).permit(:name, :description, :admin_id, :base, :factor)
    end
end
