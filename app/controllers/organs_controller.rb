class OrgansController < ApplicationController
  # before_action :authenticate_admin!
  before_action :authenticate_user!
  before_action :set_organ, only: [:show, :edit, :update, :destroy]

  def import
    Organ.import(params[:file])
    redirect_to organs_path, notice: "Datos importados!"
  end

  # GET /organs
  # GET /organs.json
  def index
    @organs = Organ.all
  end

  # GET /organs/1
  # GET /organs/1.json
  def show
  end

  # GET /organs/new
  def new
    @organ = Organ.new
  end

  # GET /organs/1/edit
  def edit
  end

  # POST /organs
  # POST /organs.json
  def create
    @organ = Organ.new(organ_params)
    @organ.admin_id = current_admin.id

    respond_to do |format|
      if @organ.save
        format.html { redirect_to @organ, notice: 'Organ was successfully created.' }
        format.json { render :show, status: :created, location: @organ }
      else
        format.html { render :new }
        format.json { render json: @organ.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organs/1
  # PATCH/PUT /organs/1.json
  def update
    @organ.admin_id = current_admin.id
    respond_to do |format|
      if @organ.update(organ_params)
        format.html { redirect_to @organ, notice: 'Organ was successfully updated.' }
        format.json { render :show, status: :ok, location: @organ }
      else
        format.html { render :edit }
        format.json { render json: @organ.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organs/1
  # DELETE /organs/1.json
  def destroy
    @organ.destroy
    respond_to do |format|
      format.html { redirect_to organs_url, notice: 'Organ was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organ
      @organ = Organ.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organ_params
      params.require(:organ).permit(:admin_id, :organ, :organ_code, :part)
    end
end
