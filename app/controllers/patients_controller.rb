class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    if params[:filter].blank?    
      if params[:tag_code].blank?
        @patients = Patient.all
      else
        @patients = Patient.where(tag_code: params[:tag_code])
      end
    else
      if params[:filter] == 'hoy'
        @patients = Patient.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
      else
        if params[:filter] == 'ayer'
          @patients = Patient.where(created_at: (Date.today - 1).beginning_of_day..(Date.today - 1).end_of_day)
        else
          if params[:filter] == 'antier'
            @patients = Patient.where(created_at: (Date.today - 2).beginning_of_day..(Date.today - 2).end_of_day)
          else
            if params[:filter] == 'trasantier'
              @patients = Patient.where(created_at: (Date.today - 3).beginning_of_day..(Date.today - 3).end_of_day)
            else
              if params[:filter] == 'semana'
                @patients = Patient.where(created_at: (Date.today - 7).beginning_of_day..Date.today.end_of_day)
              else
                if params[:filter] == 'mes'
                  @patients = Patient.where(created_at: (Date.today - 30).beginning_of_day..Date.today.end_of_day)
                end
              end
            end
          end
        end
      end
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    # @patient = Patient.new

    patients = Patient.where(id_number: params[:id_number])  #This where may bring a collection, thus the plural. For the moment, we just take the first element (0) but this needs more analisys
    if patients.length == 1
      @patient = patients.first
      @inform = patients.first.informs.build
      redirect_to patient_path(patients.first)
    else
      @patient = Patient.new(id_number: params[:id_number])
      @inform = @patient.informs.build
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
      inform.pregnancy_status = '4'
    end

    @patient.informs.first.user_id = current_user.id
    @patient.informs.first.entity_id = Branch.find(params[:patient][:informs_attributes][:"0"][:branch_id]).entity_id

    if @patient.save
      redirect_to new_patient_path, notice: 'Paciente matriculado exitosamente.'
    else
      render :new
    end
  end

  def update

    inform = @patient.informs.build(patient_params[:informs])
    inform.user_id = current_user.id
    if @patient.sex == 'M'
      inform.pregnancy_status = '4'
    end
    inform.save
    inform.tag_code = 'C' + Date.today.strftime('%y').to_s + '-' + inform.id.to_s
    inform.save

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
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:id_number, :id_type, :birth_date, :age_number, :age_type, :name1, :name2, :lastname1, :lastname2, :sex, :gender, :address, :email, :tel, :cel, :occupation, :residence_code, :municipality, :department, informs_attributes: [ :receive_date, :promoter_id, :branch_id ])
    end
end
