class PhysiciansController < ApplicationController
  before_action :authenticate_user!
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
    log = "\nCAMBIOS:\n"
    if @physician.name != physician_params[:name]
      log += "\n-NOMBRES-\nANTES:" + @physician.name + "\n- DESPUÉS: -\n" + physician_params[:name]
    else
      log += "\n-NOMBRES-\nSIN CAMBIOS."
    end
    if @physician.lastname != physician_params[:lastname]
      log += "\n-APELLIDOS-\nANTES:" + @physician.lastname + "\n- DESPUÉS: -\n" + physician_params[:lastname]
    else
      log += "\n-APELLIDOS-\nSIN CAMBIOS."
    end
    if @physician.tel != physician_params[:tel]
      log += "\n-TEL-\nANTES:" + @physician.tel + "\n- DESPUÉS: -\n" + physician_params[:tel]
    else
      log += "\n-TEL-\nSIN CAMBIOS."
    end
    if @physician.cel != physician_params[:cel]
      log += "\n-CEL-\nANTES:" + @physician.cel + "\n- DESPUÉS: -\n" + physician_params[:cel]
    else
      log += "\n-CEL-\nSIN CAMBIOS."
    end
    if @physician.email != physician_params[:email]
      log += "\n-EMAIL-\nANTES:" + @physician.email + "\n- DESPUÉS: -\n" + physician_params[:email]
    else
      log += "\n-EMAIL-\nSIN CAMBIOS."
    end
    if @physician.study1 != physician_params[:study1]
      log += "\n-study1-\nANTES:" + @physician.study1 + "\n- DESPUÉS: -\n" + physician_params[:study1]
    else
      log += "\n-study1-\nSIN CAMBIOS."
    end
    if @physician.study2 != physician_params[:study2]
      log += "\n-study2-\nANTES:" + @physician.study2 + "\n- DESPUÉS: -\n" + physician_params[:study2]
    else
      log += "\n-study2-\nSIN CAMBIOS."
    end
    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s

    if @physician.update(physician_params)
      @physician.objections.each do |objection|
        objection.closed = true
        objection.close_user_id = current_user.id
        objection.close_date = @physician.updated_at
        objection.description = objection.description + log
        objection.save
      end
      redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente actualizada.'
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
