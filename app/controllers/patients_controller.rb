class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @patients = Patient.where(created_at: date_range)
    else
      if !params[:id_number].blank?
        @patients = Patient.where(id_number: params[:tag_code])
      else
        @patients = Patient.all
      end
    end
  end

  def last20
    @informs = Inform.order(created_at: :desc).limit(20)
    @patients = []
    @informs.each do |inform|
      @patients << inform.patient
    end
    @patients = @patients.uniq
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    
  end

  # GET /patients/new
  def new
    patients = Patient.where(id_number: params[:id_number])  #This where may bring a collection, thus the plural. For the moment, we just take the first element (0) but this needs more analisys

    if patients.length > 0
      @patient = patients.first
      @inform = patients.first.informs.build.physicians.build #Creo la instancia para physician para la form
      redirect_to patient_path(patients.first)
    else
      @patient = Patient.new(id_number: params[:id_number])
      @inform = @patient.informs.build.physicians.build #Creo la instancia para physician para la form
    end
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)

    if @patient.sex == 'M'
      @patient.informs.first.pregnancy_status = '4'
    end

    @patient.informs.first.user_id = current_user.id
    @patient.informs.first.entity_id = Branch.where(id: params[:patient][:informs_attributes][:"0"][:branch_id]).first.try(:entity_id)
    @patient.informs.first.regime = Promoter.where(id: params[:patient][:informs_attributes][:"0"][:promoter_id]).first.try(:regime)

    if @patient.save
      date_range = Date.today.beginning_of_year..Date.today.end_of_year
      finf = Inform.where(created_at: date_range).last #Traingo el primer informe de año en curso. Last sería el primero desde que traigo ordenado por fecha y los más recientes son los primeros, mientras que los más viejos son los últimos. IMPORTANTE: El orden en el modelo es DESCENDENTE sobre el parámetro CREATED_AT. NO FUNCIONA BIEN si no es con ese parámetro. Los id van en el orden de creación!
      @patient.informs.first.update(tag_code: ('C' + Date.today.strftime('%y').to_s + '-' + (@patient.informs.first.id - finf.id + 1).to_s)) #Para aplicar el consecutivo, tomo el id del registro actual, le resto el del primero del año y le sumo 1. Si coinciden, es decir, estoy justo en el primer registro del año, la resta dará 0, y el consecutivo asignado será 1 ! Esto además tiene en cuenta todos los registros pues esta basado en el id.
      redirect_to new_patient_path, notice: 'Paciente matriculado exitosamente.'
    else
      render :new
    end
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: 'Patient was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    redirect_to patients_url, notice: 'Patient was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:id_number, :id_type, :birth_date, :age_number, :age_type, :name1, :name2, :lastname1, :lastname2, :sex, :gender, :address, :email, :tel, :cel, :occupation, :residence_code, :municipality, :department, informs_attributes: [ :id, :patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, physicians_attributes: [ :id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] ])
    end
end
