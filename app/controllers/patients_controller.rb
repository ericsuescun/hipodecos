class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    @tab = :series
    @patients = []
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      date_range = 2.weeks.ago..Time.zone.now
    end
    @patients = Patient.joins(:informs).where(informs: { created_at: date_range }).distinct.paginate(page: params[:page], per_page: 30)
    @patients_single = Patient.where(created_at: date_range).limit(3)

    if params[:name] != nil
      if params[:name].split(" ")[0] != nil
        @patients = Patient.where(name1: params[:name].split(" ")[0].upcase).or(Patient.where(name2: params[:name].split(" ")[0].upcase)).paginate(page: params[:page], per_page: 30)
      end

      if params[:name].split(" ")[1] != nil
        @patients = Patient.where(name1: params[:name].split(" ")[0].upcase, name2: params[:name].split(" ")[1].upcase).or(Patient.where(name1: params[:name].split(" ")[1].upcase)).or(Patient.where(name2: params[:name].split(" ")[0].upcase)).paginate(page: params[:page], per_page: 30)
      end
    end
    if params[:lastname] != nil

      if params[:lastname].split(" ")[0] != nil
        @patients = Patient.where(lastname1: params[:lastname].split(" ")[0].upcase).or(Patient.where(lastname2: params[:lastname].split(" ")[0].upcase)).paginate(page: params[:page], per_page: 30)
      end

      if params[:lastname].split(" ")[1] != nil
        @patients = Patient.where(lastname1: params[:lastname].split(" ")[0].upcase, lastname2: params[:lastname].split(" ")[1].upcase).or(Patient.where(lastname1: params[:lastname].split(" ")[1].upcase)).or(Patient.where(lastname2: params[:lastname].split(" ")[0].upcase)).paginate(page: params[:page], per_page: 30)
      end
    end

  end

  def index_names
    @tab = :series
    @patients = []
    if params[:name] != "" || params[:lastname] != ""

      if params[:name].split(" ")[0] != nil && params[:name].split(" ")[1] == nil && params[:lastname].split(" ")[0] != nil && params[:lastname].split(" ")[1] == nil
        @patients = Patient.where(
          name1: params[:name].split(" ")[0].upcase,
          lastname1: params[:lastname].split(" ")[0].upcase)
        .or(Patient.where(
          name2: params[:name].split(" ")[0].upcase,
          lastname1: params[:lastname].split(" ")[0].upcase)
        ).paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] != nil && params[:name].split(" ")[1] == nil && params[:lastname].split(" ")[0] != nil && params[:lastname].split(" ")[1] != nil
        @patients = Patient.where(
          name1: params[:name].split(" ")[0].upcase,
          lastname1: params[:lastname].split(" ")[0].upcase,
          lastname2: params[:lastname].split(" ")[1].upcase)
        .or(Patient.where(
          name2: params[:name].split(" ")[0].upcase,
          lastname1: params[:lastname].split(" ")[0].upcase,
          lastname2: params[:lastname].split(" ")[1].upcase))
        .paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] != nil && params[:name].split(" ")[1] != nil && params[:lastname].split(" ")[0] != nil && params[:lastname].split(" ")[1] == nil
        @patients = Patient.where(
          name1: params[:name].split(" ")[0].upcase,
          name2: params[:name].split(" ")[1].upcase,
          lastname1: params[:lastname].split(" ")[0].upcase)
        .paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] != nil && params[:name].split(" ")[1] != nil && params[:lastname].split(" ")[0] != nil && params[:lastname].split(" ")[1] != nil
        @patients = Patient.where(
          name1: params[:name].split(" ")[0].upcase,
          name2: params[:name].split(" ")[1].upcase,
          lastname1: params[:lastname].split(" ")[0].upcase,
          lastname2: params[:lastname].split(" ")[1].upcase)
        .paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] != nil && params[:name].split(" ")[1] != nil && params[:lastname].split(" ")[0] == nil && params[:lastname].split(" ")[1] == nil
        @patients = Patient.where(
          name1: params[:name].split(" ")[0].upcase,
          name2: params[:name].split(" ")[1].upcase)
        .paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] == nil && params[:name].split(" ")[1] == nil && params[:lastname].split(" ")[0] != nil && params[:lastname].split(" ")[1] != nil
        @patients = Patient.where(
          lastname1: params[:lastname].split(" ")[0].upcase,
          lastname2: params[:lastname].split(" ")[1].upcase)
        .paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] != nil && params[:name].split(" ")[1] == nil && params[:lastname].split(" ")[0] == nil && params[:lastname].split(" ")[1] == nil
        @patients = Patient.where(
          name1: params[:name].upcase)
        .paginate(page: params[:page], per_page: 10)
      end

      if params[:name].split(" ")[0] == nil && params[:name].split(" ")[1] == nil && params[:lastname].split(" ")[0] != nil && params[:lastname].split(" ")[1] == nil
        @patients = Patient.where(
          lastname1: params[:lastname].upcase)
        .paginate(page: params[:page], per_page: 10)
      end
    end
  end

  def index_one
    @tab = :one
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
      # @patients = Patient.where(created_at: date_range).paginate(page: params[:page], per_page: 30)
      @patients = Patient.joins(:informs).where(informs: { created_at: date_range }).distinct.paginate(page: params[:page], per_page: 30)
     else
      # @patients = Patient.where(created_at: 2.weeks.ago..Time.now).paginate(page: params[:page], per_page: 30)
      @patients = Patient.joins(:informs).where(informs: { created_at: 2.weeks.ago..Time.now }).distinct.paginate(page: params[:page], per_page: 30)
    end
  end

  # def matriculate_series
  #   @informs = Inform.order(created_at: :desc).limit(100)
  #   @patients = []
  #   @informs.each do |inform|
  #     @patients << inform.patient
  #   end
  #   @patients = @patients.uniq
  # end

  # GET /patients/1
  # GET /patients/1.json
  def show
    @inform = Inform.new
    @physician = @inform.physicians.build
    @cytology = @inform.cytologies.build

    @objections = @patient.objections
    @municipalities = Municipality.order(order: :desc)
    @municipalities.each do |municipality|
      municipality.municipality = municipality.municipality + " - " + municipality.department[0..2]
    end

    @promoters = Promoter.where(enabled: true)
    @promoters.each do |promoter|
      promoter.initials = promoter.initials + "-" + promoter.regime[0]
    end
    @promoters = @promoters.pluck(:initials, :id)

    @oldrecords = Oldrecord.where(patient_id: @patient.id)
    @oldcitos = Oldcito.where(patient_id: @patient.id)
  end

  # GET /patients/new
  def new
    patients = Patient.where(id_number: params[:id_number])  #This where may bring a collection, thus the plural. For the moment, we just take the first element (0) but this needs more analisys

    @promoters = Promoter.where(enabled: true)
    @promoters.each do |promoter|
      promoter.initials = promoter.initials + "-" + promoter.regime[0]
    end
    @promoters = @promoters.pluck(:initials, :id)

    @municipalities = Municipality.order(order: :desc)
    @municipalities.each do |municipality|
      municipality.municipality = municipality.municipality + " - " + municipality.department[0..2]
    end

    if patients.length > 0
      @patient = patients.first
      @inform = patients.first.informs.build.physicians.build #Creo la instancia para physician para la form
      redirect_to patient_path(patients.first)
    else
      @patient = Patient.new(id_number: params[:id_number])
      @inform = @patient.informs.build.physicians.build #Creo la instancia para physician para la form
    end
  end

  def new_single
    @patient = Patient.new
  end

  def create_new
    patient = Patient.new(patient_params)
    if patient.save
      redirect_to patient, notice: "Paciente sin informe creado con éxito!"
    else
      redirect_to patients_new_single_path
    end


  end

  def new_series
    patients = Patient.where(id_number: params[:id_number])  #This where may bring a collection, thus the plural. For the moment, we just take the first element (0) but this needs more analisys
    @promoters = Promoter.where(enabled: true)
    @promoters.each do |promoter|
      promoter.initials = promoter.initials + "-" + promoter.regime[0]
    end
    @promoters = @promoters.pluck(:initials, :id)

    @municipalities = Municipality.order(order: :desc)
    @municipalities.each do |municipality|
      municipality.municipality = municipality.municipality + " - " + municipality.department[0..2]
    end

    if patients.length > 0
      @patient = patients.first
      @inform = patients.first.informs.build.physicians.build #Creo la instancia para physician para la form
      if params[:inf_type]
        redirect_to patient_path(patients.first) + "?inf_type=" + params[:inf_type]
      else
        redirect_to patient_path(patients.first)
      end

    else

      if params[:inf_type] == "cito"
        @patient = Patient.new(id_number: params[:id_number], sex: "F")
        @inform = @patient.informs.build
        @cytology = @inform.cytologies.build
      else
        @patient = Patient.new(id_number: params[:id_number])
        @inform = @patient.informs.build
      end
      @physician = @inform.physicians.build #Creo la instancia para physician para la form

    end
  end

  def edit
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.sex == 'M'
      @patient.informs.first.pregnancy_status = '4'
    end

    @patient.informs.first.user_id = current_user.id
    @patient.informs.first.entity_id = Branch.where(id: params[:patient][:informs_attributes][:"0"][:branch_id]).first.try(:entity_id)

    @patient.password = params[:patient][:id_number]
    @patient.password_confirmation = params[:patient][:id_number]

    date_range = Date.today.beginning_of_year..Date.today.end_of_year

    if params[:patient][:informs_attributes][:"0"][:inf_type] == "clin"
        adjust = 0
        adjust = Oldrecord.where(clave: 'C', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1 + adjust
        @patient.informs.first.tag_code = "C" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        @patient.informs.first.consecutive = consecutive.to_i
    else
      if params[:patient][:informs_attributes][:"0"][:inf_type] == "hosp"
        adjust = 0
        adjust = Oldrecord.where(clave: 'H', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1 + adjust
        @patient.informs.first.tag_code = "H" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        @patient.informs.first.consecutive = consecutive.to_i
      else
        adjust = 0
        adjust = Oldcito.where(clave: 'K', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1 + adjust
        @patient.informs.first.tag_code = "K" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        @patient.informs.first.consecutive = consecutive.to_i
      end
    end

    if @patient.save
      inform = @patient.informs.first #Si el informe más reciente fue cito, preparo toda la info
      if inform.inf_type == 'cito'
        #Se crea el recipiente
        @recipient = inform.recipients.build
        @recipient.tag = generate_rec_tag(inform)
        @recipient.user_id = current_user.id
        @recipient.description = ""
        @recipient.save

        #Se crea el extendido
        @sample = inform.samples.build
        @sample.user_id = current_user.id
        @sample.name = "Extendido"
        @sample.included = false
        @sample.recipient_tag = @recipient.tag
        @sample.sample_tag = generate_letter_tag(inform)
        @sample.organ_code = "Vagina"
        @sample.description = ""
        @sample.fragment = 1
        @sample.save

        #Se crea el CUP
        branch = Branch.find(inform.branch_id)
        entity = branch.entity
        cost = Value.where(codeval_id: Codeval.where(code: "898001").first.id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.value

        price =  Factor.where(codeval_id: Codeval.where(code: "898001").first.id, rate_id: branch.entity.rate_id).first.price
        margin =  price - cost

        cost_description = Cost.where(id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:name)
        value_description = Value.where(codeval_id: Codeval.where(code: "898001").first.id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:description)
        rate_description = Rate.where(id: branch.entity.rate_id).first.try(:name)
        factor_description = Factor.where(codeval_id: Codeval.where(code: "898001").first.id, rate_id: branch.entity.rate_id).first.try(:description)

        price_description = cost_description + ". " + rate_description + ". Notas costo: " + value_description + ". Notas factor: " + factor_description

        @study = inform.studies.build(
          user_id: current_user.id,
          codeval_id: Codeval.where(code: "898001").first.id,
          factor: 1,
          cost: cost,
          price: price,
          margin: margin,
          price_description: price_description
          )
        @study.save

        #Se crea el slide
        inform.slides.create(slide_tag: @sample.sample_tag, user_id: current_user.id) #Se crea un slide con el mismo tag de la sample
        @sample.update(slide_tag: @sample.sample_tag)  #Se guarda el tag creado en la sample para que queden asociados
        # inform.update(inf_status: "placado")
      # else
        # inform.update(inf_status: "matriculado")
      end
      redirect_to inform_path(@patient.informs.first), notice: 'Paciente matriculado exitosamente.'
    else
      redirect_to patients_new_series_path + "?inf_type=" + params[:inf_type] + "&id_number=" + params[:id_number]
    end
  end

  def create_series
    @patient = Patient.new(patient_params)

    if @patient.sex == 'M'
      @patient.informs.first.pregnancy_status = '4'
    end

    @patient.informs.first.user_id = current_user.id
    @patient.informs.first.entity_id = Branch.where(id: params[:patient][:informs_attributes][:"0"][:branch_id]).first.try(:entity_id)
    
    @patient.password = params[:patient][:id_number]
    @patient.password_confirmation = params[:patient][:id_number]

    date_range = Date.today.beginning_of_year..Date.today.end_of_year
    adjust = 0
    adjust = Oldrecord.where(clave: 'C', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'

    consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1 + adjust
    @patient.informs.first.tag_code = "C" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
    @patient.informs.first.consecutive = consecutive.to_i

    if params[:patient][:informs_attributes][:"0"][:inf_type] == "clin"
        adjust = 0
        adjust = Oldrecord.where(clave: 'C', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1 + adjust
        @patient.informs.first.tag_code = "C" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        @patient.informs.first.consecutive = consecutive.to_i
    else
      if params[:patient][:informs_attributes][:"0"][:inf_type] == "hosp"
        adjust = 0
        adjust = Oldrecord.where(clave: 'H', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1 + adjust
        @patient.informs.first.tag_code = "H" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        @patient.informs.first.consecutive = consecutive.to_i
      else
        adjust = 0
        adjust = Oldcito.where(clave: 'K', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1 + adjust
        @patient.informs.first.tag_code = "K" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
        @patient.informs.first.consecutive = consecutive.to_i
      end
    end

    if @patient.save

      inform = @patient.informs.first #Si el informe más reciente fue cito, preparo toda la info
      if inform.inf_type == 'cito'
        #Se crea el recipiente
        @recipient = inform.recipients.build
        @recipient.tag = generate_rec_tag(inform)
        @recipient.user_id = current_user.id
        @recipient.description = ""
        @recipient.save

        #Se crea el extendido
        @sample = inform.samples.build
        @sample.user_id = current_user.id
        @sample.name = "Extendido"
        @sample.included = false
        @sample.recipient_tag = @recipient.tag
        @sample.sample_tag = generate_letter_tag(inform)
        @sample.organ_code = "Vagina"
        @sample.description = ""
        @sample.fragment = 1
        @sample.save

        #Se crea el CUP
        branch = Branch.find(inform.branch_id)
        entity = branch.entity
        cost = Value.where(codeval_id: Codeval.where(code: "898001").first.id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.value

        price =  Factor.where(codeval_id: Codeval.where(code: "898001").first.id, rate_id: branch.entity.rate_id).first.price
        margin =  price - cost

        cost_description = Cost.where(id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:name)
        value_description = Value.where(codeval_id: Codeval.where(code: "898001").first.id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:description)
        rate_description = Rate.where(id: branch.entity.rate_id).first.try(:name)
        factor_description = Factor.where(codeval_id: Codeval.where(code: "898001").first.id, rate_id: branch.entity.rate_id).first.try(:description)

        price_description = cost_description + ". " + rate_description + ". Notas costo: " + value_description + ". Notas factor: " + factor_description

        @study = inform.studies.build(
          user_id: current_user.id,
          codeval_id: Codeval.where(code: "898001").first.id,
          factor: 1,
          cost: cost,
          price: price,
          margin: margin,
          price_description: price_description
          )
        @study.save

        #Se crea el slide
        inform.slides.create(slide_tag: @sample.sample_tag, user_id: current_user.id) #Se crea un slide con el mismo tag de la sample
        @sample.update(slide_tag: @sample.sample_tag)  #Se guarda el tag creado en la sample para que queden asociados
        # inform.update(inf_status: "placado")
      # else
        # inform.update(inf_status: "matriculado")
      end
      redirect_to patients_path + "?inf_type=" + params[:patient][:informs_attributes][:"0"][:inf_type], notice: 'Paciente matriculado exitosamente.'
    else
      render :new_series
    end
    @promoters = Promoter.where(enabled: true)
    @promoters = @promoters.pluck(:initials, :id)
    @municipalities = Municipality.all
    @municipalities.each do |municipality|
      municipality.municipality = municipality.municipality + " - " + municipality.department[0..2]
    end
  end

  def update

    log = "\nCAMBIOS:\n"

    if @patient.id_number != params[:patient][:id_number]
      log += "IDENTIFICACION: ANTES:" + @patient.id_number + " DESPUÉS: " + params[:patient][:id_number].to_s + "\n"
    else
      log += "IDENTIFICACION: SIN CAMBIOS." + "\n"
    end

    if @patient.id_type != params[:patient][:id_type]
      log += "TIPO DE IDENTIFICACION: ANTES:" + @patient.id_type + " DESPUÉS: " + params[:patient][:id_type].to_s + "\n"
    else
      log += "TIPO DE IDENTIFICACION: SIN CAMBIOS." + "\n"
    end

    if @patient.birth_date != params[:patient][:birth_date]
      log += "FECHA DE NACIMIENTO: ANTES:" + @patient.birth_date.to_s + " DESPUÉS: " + params[:patient][:birth_date].to_s + "\n"
    else
      log += "FECHA DE NACIMIENTO: SIN CAMBIOS." + "\n"
    end

    if @patient.name1 != params[:patient][:name1]
      log += "PRIMER NOMBRE: ANTES:" + @patient.name1.to_s + " DESPUÉS: " + params[:patient][:name1].to_s + "\n"
    else
      log += "PRIMER NOMBRE: nSIN CAMBIOS." + "\n"
    end

    if @patient.name2 != params[:patient][:name2]
      log += "SEGUNDO NOMBRE: ANTES:" + @patient.name2.to_s + " DESPUÉS: " + params[:patient][:name2].to_s + "\n"
    else
      log += "SEGUNDO NOMBRE: SIN CAMBIOS." + "\n"
    end

    if @patient.lastname1 != params[:patient][:lastname1]
      log += "PRIMER APELLIDO: ANTES:" + @patient.lastname1.to_s + " DESPUÉS: " + params[:patient][:lastname1].to_s + "\n"
    else
      log += "PRIMER APELLIDO: SIN CAMBIOS." + "\n"
    end

    if @patient.lastname2 != params[:patient][:lastname2]
      log += "SEGUNDO APELLIDO: ANTES:" + @patient.lastname2.to_s + " DESPUÉS: " + params[:patient][:lastname2].to_s + "\n"
    else
      log += "SEGUNDO APELLIDO:SIN CAMBIOS." + "\n"
    end

    if @patient.sex != params[:patient][:sex]
      log += "SEXO: ANTES:" + @patient.sex + " DESPUÉS: " + params[:patient][:sex].to_s + "\n"
    else
      log += "SEXO: SIN CAMBIOS." + "\n"
    end

    if @patient.gender != params[:patient][:gender]
      log += "GÉNERO: ANTES:" + @patient.gender.to_s + " DESPUÉS: " + params[:patient][:gender].to_s + "\n"
    else
      log += "GÉNERO: SIN CAMBIOS." + "\n"
    end

    log += "\nFECHA: " + DateTime.now.to_s + "\nUSUARIO: " + current_user.email.to_s

    if @patient.update(patient_params)

      objection = @patient.objections.build(
          user_id: current_user.id,
          obcode_id: 23,
          responsible_user_id: nil, #@patient.user_id,
          description: log

        )
      objection.save

      if params[:patient][:inform_id] != nil
        inform = Inform.find(params[:patient][:inform_id])
        if inform.inf_status == "revision"
          redirect_to show_revision_inform_path(inform), notice: 'Informe exitosamente actualizado.'
        else
          redirect_to @patient, notice: 'Paciente exitosamente editado.'
        end
      else
        redirect_to patient_path(@patient, inf_type: params[:patient][:inf_type]), notice: 'Paciente exitosamente editado.'
      end


    else
      render :edit
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    redirect_to matriculate_series_patients_path, notice: 'Paciente exitosamente borrado.'
  end

  private
    def generate_rec_tag(inform)
      next_number = 1
      answer = false
      if inform.recipients.empty?
        return inform.tag_code + '-R1'
      end

      inform.recipients.length.times {
        inform.recipients.each do |rec|
          if (rec.tag == inform.tag_code + '-R' + next_number.to_s)
            next_number = next_number + 1
            break
          end
        end
      }

      return inform.tag_code + '-R' + next_number.to_s
    end

    def generate_number_tag(sample)
      if sample.sample_tag[-1] =~ /[A-Z]/
        # sample.update(sample_tag: sample.sample_tag + '1')
        return sample.sample_tag + '2'
      end
      if sample.sample_tag[-1] =~ /[0-9]/
        return sample.sample_tag[0..-2] + (sample.sample_tag[-1].to_i + 1).to_s
      end
    end

    def generate_letter_tag(inform)
      next_letter = 'A'
      answer = false
      if inform.samples.empty?
        return inform.tag_code + '-A'
      end

      inform.samples.length.times {
        inform.samples.each do |sample|
          if (sample.sample_tag == inform.tag_code + '-' + next_letter) || (sample.sample_tag == inform.tag_code + '-' + next_letter + '1')
            next_letter = (next_letter.ord + 1).chr
            break
          end
        end
      }

      return inform.tag_code + '-' + next_letter
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:id_number, :id_type, :birth_date, :age_number, :age_type, :name1, :name2, :lastname1, :lastname2, :sex, :gender, :address, :email, :tel, :cel, :occupation, :residence_code, :municipality, :department, informs_attributes: [ :id, :patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, :p_age, :p_age_type, :p_address, :p_email, :p_tel, :p_cel, :p_occupation, :p_residence_code, :p_municipality, :p_department, :inf_type, cytologies_attributes: [:id, :inform_id, :pregnancies, :last_mens, :prev_appo, :sample_date, :last_result, :birth_control, :user_id, :suggestion], physicians_attributes: [ :id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] ])
    end
end
