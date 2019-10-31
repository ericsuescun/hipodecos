class DiagcodesController < ApplicationController
  before_action :set_diagcode, only: [:show, :edit, :update, :destroy]

  # GET /diagcodes
  # GET /diagcodes.json
  def index
    @diagcodes = Diagcode.all
  end

  # GET /diagcodes/1
  # GET /diagcodes/1.json
  def show
  end

  # GET /diagcodes/new
  def new
    @diagcode = Diagcode.new
  end

  # GET /diagcodes/1/edit
  def edit
  end

  # POST /diagcodes
  # POST /diagcodes.json
  def create
    @diagcode = Diagcode.new(diagcode_params)

    respond_to do |format|
      if @diagcode.save
        format.html { redirect_to @diagcode, notice: 'Diagcode was successfully created.' }
        format.json { render :show, status: :created, location: @diagcode }
      else
        format.html { render :new }
        format.json { render json: @diagcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diagcodes/1
  # PATCH/PUT /diagcodes/1.json
  def update
    respond_to do |format|
      if @diagcode.update(diagcode_params)
        format.html { redirect_to @diagcode, notice: 'Diagcode was successfully updated.' }
        format.json { render :show, status: :ok, location: @diagcode }
      else
        format.html { render :edit }
        format.json { render json: @diagcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diagcodes/1
  # DELETE /diagcodes/1.json
  def destroy
    @diagcode.destroy
    respond_to do |format|
      format.html { redirect_to diagcodes_url, notice: 'Diagcode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diagcode
      @diagcode = Diagcode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diagcode_params
      params.require(:diagcode).permit(:admin_id, :organ, :feature1, :feature2, :feature3, :feature4, :feature5, :description, :pss_code, :who_code, :score, :order)
    end
end
