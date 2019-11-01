class ObcodesController < ApplicationController
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

    respond_to do |format|
      if @obcode.save
        format.html { redirect_to @obcode, notice: 'Obcode was successfully created.' }
        format.json { render :show, status: :created, location: @obcode }
      else
        format.html { render :new }
        format.json { render json: @obcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /obcodes/1
  # PATCH/PUT /obcodes/1.json
  def update
    respond_to do |format|
      if @obcode.update(obcode_params)
        format.html { redirect_to @obcode, notice: 'Obcode was successfully updated.' }
        format.json { render :show, status: :ok, location: @obcode }
      else
        format.html { render :edit }
        format.json { render json: @obcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /obcodes/1
  # DELETE /obcodes/1.json
  def destroy
    @obcode.destroy
    respond_to do |format|
      format.html { redirect_to obcodes_url, notice: 'Obcode was successfully destroyed.' }
      format.json { head :no_content }
    end
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
