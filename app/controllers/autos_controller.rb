class AutosController < ApplicationController
  # before_action :authenticate_admin!
  before_action :authenticate_user!
  before_action :set_auto, only: [:show, :edit, :update, :destroy]

  # GET /autos
  # GET /autos.json
  def index
    @autos = Auto.all
  end

  # GET /autos/1
  # GET /autos/1.json
  def show
    
  end


  # GET /autos/new
  def new
    @auto = Auto.new
  end

  # GET /autos/1/edit
  def edit
  end

  # POST /autos
  # POST /autos.json
  def create
    # @auto = Auto.new(auto_params)
    @diagcode = Diagcode.find(params[:diagcode_id])
    @auto = @diagcode.autos.build(auto_params) 
    @auto.user_id = current_user.id
    @auto.admin_id = 1

    respond_to do |format|
      if @auto.save
        format.html { redirect_to diagcode_path(@diagcode), notice: 'Auto was successfully created.' }
        format.json { render :show, status: :created, location: @auto }
      else
        format.html { render :new }
        format.json { render json: @auto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /autos/1
  # PATCH/PUT /autos/1.json
  def update
    respond_to do |format|
      if @auto.update(auto_params)
        format.html { redirect_to diagcode_path(@diagcode), notice: 'Auto was successfully updated.' }
        format.json { render :show, status: :ok, location: @auto }
      else
        format.html { render :edit }
        format.json { render json: @auto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /autos/1
  # DELETE /autos/1.json
  def destroy
    @auto.destroy
    respond_to do |format|
      format.html { redirect_to diagcode_path(@diagcode), notice: 'Auto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auto
      @auto = Auto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auto_params
      params.require(:auto).permit(:diagcode_id, :user_id, :admin_id, :title, :body, :param1, :param2, :param3, :param4, :param5)
    end
end
