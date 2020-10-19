class CodevalsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_codeval, only: [:show, :edit, :update, :destroy]

  def import
    Codeval.import(params[:file])
    redirect_to codevals_path, notice: "Datos importados!"
  end

  # GET /codevals
  # GET /codevals.json
  def index
    @tab = :admins
    @codevals = Codeval.all
  end

  # GET /codevals/1
  # GET /codevals/1.json
  def show
  end

  # GET /codevals/new
  def new
    @codeval = Codeval.new
  end

  # GET /codevals/1/edit
  def edit
  end

  # POST /codevals
  # POST /codevals.json
  def create_old
    @codeval = Codeval.new(codeval_params)
    @codeval.admin_id = current_admin.id

    if @codeval.save
      redirect_to @codeval, notice: 'CUPS exitosamente creado.'
    else
      render :new
    end
  end

  def create
    @codeval = Codeval.new(codeval_params)
    @codeval.admin_id = current_admin.id
    @costs = Cost.all
    @rates = Rate.all

    if @costs.count == 0
      if @codeval.save
        redirect_to @codeval, notice: 'CUPS exitosamente creado.'
      else
        render :new
      end
    else
      if @codeval.save
        @costs.each do |cost|
          value = Value.new(codeval_id: @codeval.id, cost_id: cost.id, value: params[:codeval][:value], description: cost.description, admin_id: current_admin.id)
          value.save
        end
        if @rates.count != 0
          @rates.each do |rate|
            factor = Factor.new(codeval_id: @codeval.id, rate_id: rate.id, factor: rate.factor, description: rate.description, admin_id: current_admin.id, cost_id: rate.cost_id, price: params[:codeval][:value].to_f * (1 + (rate.factor.to_f / 100)) )
            factor.save
          end
        end
        redirect_to @codeval, notice: 'CUPS exitosamente creado. Tablas de costos y tarifas actualizadas.'
      end
    end


    
  end

  # PATCH/PUT /codevals/1
  # PATCH/PUT /codevals/1.json
  def update
    if @codeval.update(codeval_params)
      redirect_to @codeval, notice: 'CUPS exitosamente actualizado.'
    else
      render :edit
    end
  end

  # DELETE /codevals/1
  # DELETE /codevals/1.json
  def destroy
    @codeval.destroy
    redirect_to codevals_url, notice: 'CUPS exitosamente borrado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_codeval
      @codeval = Codeval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def codeval_params
      params.require(:codeval).permit(:name, :code, :description, :origin_system, :ref_code, :admin_id)
    end
end
