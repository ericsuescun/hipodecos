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

  def fast_new_form

  end

  def fast_new
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

    @patient.password = params[:patient][:id_number]
    @patient.password_confirmation = params[:patient][:id_number]

    date_range = Date.today.beginning_of_year..Date.today.end_of_year

    if params[:patient][:informs_attributes][:"0"][:inf_type] == "clin"
        consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1
        @patient.informs.first.tag_code = "C" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        puts patient.informs.first.tag_code
    else
      if params[:patient][:informs_attributes][:"0"][:inf_type] == "hosp"
        consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1
        @patient.informs.first.tag_code = "H" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        puts patient.informs.first.tag_code
      else
        consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1
        @patient.informs.first.tag_code = "K" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        puts patient.informs.first.tag_code
      end #La instancia de inform hace que se el conteo COUNT de +1. Por eso consecutive no le sumo 1
    end

    puts @patient
    if @patient.save
      redirect_to inform_path(@patient.informs.first), notice: 'Paciente matriculado exitosamente.'
    else
      render :fast_new
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
      params.require(:patient).permit(:id_number, :id_type, :birth_date, :age_number, :age_type, :name1, :name2, :lastname1, :lastname2, :sex, :gender, :address, :email, :tel, :cel, :occupation, :residence_code, :municipality, :department, informs_attributes: [ :id, :patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, :p_age, :p_age_type, :p_address, :p_email, :p_tel, :p_cel, :p_occupation, :p_residence_code, :p_municipality, :p_department, :inf_type, physicians_attributes: [ :id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] ])
    end
end
