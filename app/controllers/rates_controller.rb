class RatesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

  # GET /rates
  # GET /rates.json
  def index
    @tab = :admins
    @rates = Rate.all
  end

  # GET /rates/1
  # GET /rates/1.json
  def show
  end

  # GET /rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /rates
  # POST /rates.json
  def create
    @rate = Rate.new(rate_params)

    @rate.admin_id = current_admin.id

    @rate.save

    @codevals = Codeval.all

    @codevals.each do |codeval|
      factor = Factor.new
      factor.codeval = codeval
      factor.rate = @rate
      factor.factor = @rate.factor
      factor.description = @rate.description
      factor.admin_id = current_admin.id
      factor.price = Value.where(codeval_id: codeval.id, cost_id: params[:rate][:cost_id]).first.value * (1 + (factor.factor / 100))
      factor.cost_id = params[:rate][:cost_id]
      factor.save
    end

    redirect_to @rate, notice: 'Tarifa exitosamente creada.'
  end

  # PATCH/PUT /rates/1
  # PATCH/PUT /rates/1.json
  def update
        
    @rate.factors.each do |factor|
      # factor.update(factor: rate_params[:factor], description: rate_params[:description])

      factor.factor = params[:rate][:factor]
      factor.description = params[:rate][:description]
      factor.admin_id = current_admin.id
      factor.price = Value.where(codeval_id: factor.codeval_id, cost_id: params[:rate][:cost_id]).first.value * (1 + (params[:rate][:factor].to_f / 100))
      factor.cost_id = params[:rate][:cost_id]
      factor.save      
    end #Traigo toda la colecciones de factores para la Rate actual y los recorro


    if @rate.update(rate_params)
      redirect_to @rate, notice: 'Tarifa exitosamente actualizada.'
    else
      render :edit
    end

  end

  # DELETE /rates/1
  # DELETE /rates/1.json
  def destroy
    @rate.destroy
    redirect_to rates_url, notice: 'Tarifa exitosamente borrada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate
      @rate = Rate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
      params.require(:rate).permit(:name, :description, :admin_id, :factor, :cost_id)
    end
end
