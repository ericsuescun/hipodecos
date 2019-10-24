class PhysiciansController < ApplicationController
  before_action :set_physician, only: [:show, :edit, :update, :destroy]

  # GET /physicians
  # GET /physicians.json
  def index
    @physicians = Physician.all
  end

  # GET /physicians/1
  # GET /physicians/1.json
  def show
  end

  # GET /physicians/new
  def new
    @physician = Physician.new
  end

  # GET /physicians/1/edit
  def edit
  end

  # POST /physicians
  # POST /physicians.json
  def create
    inform = Inform.find(params[:inform_id])
    physician = inform.physicians.build(physician_params)
    physician.user_id = current_user.id

    if physician.save
      redirect_to inform, notice: 'Doctor asignado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /physicians/1
  # PATCH/PUT /physicians/1.json
  def update
    if @physician.update(physician_params)
      redirect_to inform_path(@inf), notice: 'Doctor editado exitosamente..'
    else
      render :edit
    end
  end

  # DELETE /physicians/1
  # DELETE /physicians/1.json
  def destroy
    @physician.destroy
    redirect_to inform_path(@inf), notice: 'Doctor borrado exitosamente.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_physician
      @physician = Physician.find(params[:id])
      @inf = @physician.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def physician_params
      params.require(:physician).permit(:inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2)
    end
end
