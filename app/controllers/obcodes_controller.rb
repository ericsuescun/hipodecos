class ObcodesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_obcode, only: [:show, :edit, :update, :destroy]

  def import
    Obcode.import(params[:file])
    redirect_to obcodes_path, notice: "Datos importados!"
  end

  # GET /obcodes
  # GET /obcodes.json
  def index
    @obcodes = Obcode.all
  end

  # GET /obcodes/1
  # GET /obcodes/1.json
  def show
  end

  # GET /obcodes/new
  def new
    @obcode = Obcode.new
  end

  # GET /obcodes/1/edit
  def edit
  end

  # POST /obcodes
  # POST /obcodes.json
  def create
    @obcode = Obcode.new(obcode_params)
    @obcode.admin_id = current_admin.id

    if @obcode.save
      redirect_to @obcode, notice: 'Obcode was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /obcodes/1
  # PATCH/PUT /obcodes/1.json
  def update
    if @obcode.update(obcode_params)
      redirect_to @obcode, notice: 'Obcode was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /obcodes/1
  # DELETE /obcodes/1.json
  def destroy
    @obcode.destroy
    redirect_to obcodes_url, notice: 'Obcode was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_obcode
      @obcode = Obcode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def obcode_params
      params.require(:obcode).permit(:admin_id, :title, :process, :score, :order)
    end
end
