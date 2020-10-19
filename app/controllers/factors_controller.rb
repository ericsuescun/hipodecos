class FactorsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_factor, only: [:show, :edit, :update, :destroy]

  # GET /factors
  # GET /factors.json
  def index
    @factors = Factor.all
  end

  # GET /factors/1
  # GET /factors/1.json
  def show
  end

  # GET /factors/new
  def new
    @factor = Factor.new
  end

  # GET /factors/1/edit
  def edit
  end

  # POST /factors
  # POST /factors.json
  def create
    @factor = Factor.new(factor_params)

    if @factor.save
      redirect_to @factor, notice: 'Tarifa exitosamente creada.'
    else
      render :new
    end
  end

  # PATCH/PUT /factors/1
  # PATCH/PUT /factors/1.json
  def update
    @factor.admin_id = current_admin.id
    @factor.description = params[:factor][:description]
    cost = Value.where(codeval_id: @factor.codeval_id, cost_id: @factor.cost_id).first.value
    @factor.factor = 100 * (params[:factor][:price].to_f - cost) / cost
    @factor.price = params[:factor][:price]

    if @factor.save
      redirect_to rate_path(@factor.rate_id), notice: 'Tarifa exitosamente actualizada.'
    else
      render :edit
    end
  end

  # DELETE /factors/1
  # DELETE /factors/1.json
  def destroy
    @factor.destroy
    respond_to do |format|
      format.html { redirect_to factors_url, notice: 'Tarifa exitosamente borrada.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_factor
      @factor = Factor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def factor_params
      params.require(:factor).permit(:codeval_id, :rate_id, :factor, :description, :admin_id, :cost_id, :price)
    end
end
