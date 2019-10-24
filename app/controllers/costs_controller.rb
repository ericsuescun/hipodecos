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
        value.value = codeval.values.find_by_cost_id(@cost.base.to_i).value * @cost.factor
      end
      value.description = @cost.description
      value.admin_id = current_admin.id
      value.save
    end

    redirect_to @cost, notice: 'Tabla de costos creada exitosamente.'

  end

  # PATCH/PUT /costs/1
  # PATCH/PUT /costs/1.json
  def update
    respond_to do |format|
      if @cost.update(cost_params)
        format.html { redirect_to @cost, notice: 'Costo exitosamente actualizado.' }
        format.json { render :show, status: :ok, location: @cost }
      else
        format.html { render :edit }
        format.json { render json: @cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /costs/1
  # DELETE /costs/1.json
  def destroy
    @cost.destroy
    respond_to do |format|
      format.html { redirect_to costs_url, notice: 'Costo exitosamente borrado.' }
      format.json { head :no_content }
    end
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
