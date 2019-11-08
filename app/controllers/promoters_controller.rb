class PromotersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_promoter, only: [:show, :edit, :update, :destroy]

  def import
    Promoter.import(params[:file])
    redirect_to promoters_path, notice: "Datos importados!"
  end

  # GET /promoters
  # GET /promoters.json
  def index
    @tab = :admins
    @promoters = Promoter.all
  end

  # GET /promoters/1
  # GET /promoters/1.json
  def show
  end

  # GET /promoters/new
  def new
    @promoter = Promoter.new
  end

  # GET /promoters/1/edit
  def edit
  end

  # POST /promoters
  # POST /promoters.json
  def create
    @promoter = Promoter.new(promoter_params)

      if @promoter.save
        redirect_to promoters_path, notice: 'EPS creada con éxito.'
      else
        render :new
      end
  end

  # PATCH/PUT /promoters/1
  # PATCH/PUT /promoters/1.json
  def update
    if @promoter.update(promoter_params)
      redirect_to @promoter, notice: 'EPS exitosamente actualizada.'
    else
      render :edit
    end
  end

  # DELETE /promoters/1
  # DELETE /promoters/1.json
  def destroy
    @promoter.destroy
      redirect_to promoters_url, notice: 'Promoter was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promoter
      @promoter = Promoter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def promoter_params
      params.require(:promoter).permit(:name, :initials, :code, :regime)
    end
end
