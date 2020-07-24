class CitocodesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_citocode, only: [:show, :edit, :update, :destroy]

  def import
    Citocode.import(params[:file])
    redirect_to citocodes_path, notice: "Datos importados!"
  end

  # GET /citocodes
  # GET /citocodes.json
  def index
    @citocodes = Citocode.all
  end

  # GET /citocodes/1
  # GET /citocodes/1.json
  def show
  end

  # GET /citocodes/new
  def new
    @citocode = Citocode.new
  end

  # GET /citocodes/1/edit
  def edit
  end

  # POST /citocodes
  # POST /citocodes.json
  def create
    @citocode = Citocode.new(citocode_params)

    respond_to do |format|
      if @citocode.save
        format.html { redirect_to @citocode, notice: 'Citocode was successfully created.' }
        format.json { render :show, status: :created, location: @citocode }
      else
        format.html { render :new }
        format.json { render json: @citocode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /citocodes/1
  # PATCH/PUT /citocodes/1.json
  def update
    respond_to do |format|
      if @citocode.update(citocode_params)
        format.html { redirect_to @citocode, notice: 'Citocode was successfully updated.' }
        format.json { render :show, status: :ok, location: @citocode }
      else
        format.html { render :edit }
        format.json { render json: @citocode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /citocodes/1
  # DELETE /citocodes/1.json
  def destroy
    @citocode.destroy
    respond_to do |format|
      format.html { redirect_to citocodes_url, notice: 'Citocode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_citocode
      @citocode = Citocode.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def citocode_params
      params.require(:citocode).permit(:admin_id, :cito_code, :description, :result_type, :score, :order)
    end
end
