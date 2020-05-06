class AutomaticsController < ApplicationController
  before_action :set_automatic, only: [:show, :edit, :update, :destroy]

  # GET /automatics
  # GET /automatics.json
  def index
    @automatics = Automatic.all
  end

  # GET /automatics/1
  # GET /automatics/1.json
  def show
  end

  # GET /automatics/new
  def new
    @automatic = Automatic.new
  end

  # GET /automatics/1/edit
  def edit
  end

  # POST /automatics
  # POST /automatics.json
  def create
    @automatic = Automatic.new(automatic_params)

    respond_to do |format|
      if @automatic.save
        format.html { redirect_to @automatic, notice: 'El automático fue creado exitosamente!' }
        format.json { render :show, status: :created, location: @automatic }
      else
        format.html { render :new }
        format.json { render json: @automatic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /automatics/1
  # PATCH/PUT /automatics/1.json
  def update
    respond_to do |format|
      if @automatic.update(automatic_params)
        format.html { redirect_to @automatic, notice: 'El automático fue actualizado exitosamente!' }
        format.json { render :show, status: :ok, location: @automatic }
      else
        format.html { render :edit }
        format.json { render json: @automatic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /automatics/1
  # DELETE /automatics/1.json
  def destroy
    @automatic.destroy
    respond_to do |format|
      format.html { redirect_to automatics_url, notice: 'El automático y sus pasos fueron borrados exitosamente!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_automatic
      @automatic = Automatic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def automatic_params
      params.require(:automatic).permit(:organ, :title)
    end
end
