class InformsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inform, only: [:show, :show_revision, :edit, :update, :destroy, :preview, :descr_micro, :clear_revision, :set_revision, :set_ready, :autos_micro, :anulate]

  # GET /informs
  # GET /informs.json
  def index
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    if params[:tag_code]
      @informs = Inform.where(tag_code: params[:tag_code]).paginate(page: params[:page], per_page: 10)
    else
      @informs = Inform.where(receive_date: date_range, inf_type: params[:inf_type]).paginate(page: params[:page], per_page: 10)
    end
  end

  def index_oldrecords
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    @oldrecords = Oldrecord.where(fecharec: date_range, clave: params[:inf_type] == 'clin' ? "C" : params[:inf_type] == 'hosp' ? "H" : "K").paginate(page: params[:page], per_page: 10)
  end

  def index_oldcitos
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @oldcitos = Oldcito.where(fecharec: date_range, clave: "K").paginate(page: params[:page], per_page: 60)
  end

  def last20
    @informs = Inform.all.limit(20)
    @oldrecords = Oldrecord.all.limit(20)
    # @informs = []
  end

  def index_revision
    @tab = :revision
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: "revision")
    # else
    #   @informs = Inform.where(inf_status: "revision")
    # end
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(receive_date: date_range, inf_status: "revision").paginate(page: params[:page], per_page: 10)
  end

  def index_ready
    @tab = :ready
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: "ready")
    # else
    #   @informs = Inform.where(inf_status: "ready")
    # end
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(delivery_date: date_range, inf_status: "ready").paginate(page: params[:page], per_page: 10)
  end

  def publish
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "published", delivery_date: Time.now})
    if params[:init_date]
      redirect_to informs_index_published_path + "?init_date=#{params[:init_date]}&final_date=#{params[:final_date]}"
    else
      redirect_to informs_index_published_path
    end
  end

  def index_published
    @tab = :published

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(delivery_date: date_range, inf_status: "published").or(Inform.where(delivery_date: date_range, inf_status: "downloaded")).paginate(page: params[:page], per_page: 10)
  end

  def unpublish
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "ready"})
    if params[:init_date]
      redirect_to informs_index_ready_path + "?init_date=#{params[:init_date]}&final_date=#{params[:final_date]}"
    else
      redirect_to informs_index_ready_path
    end
  end

  def index_downloaded
    @tab = :published

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(download_date: date_range, inf_status: "downloaded").paginate(page: params[:page], per_page: 10)
  end

  def undownload
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "published"})
    if params[:init_date]
      redirect_to informs_index_published_path + "?init_date=#{params[:init_date]}&final_date=#{params[:final_date]}"
    else
      redirect_to informs_index_published_path
    end
  end

  def descr_micros
    @tab = :pathologist
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: nil, pathologist_id: current_user.id).or(Inform.where(receive_date: date_range, inf_status: "revision_cyto", pathologist_id: current_user.id))
    # else
    #   @informs = Inform.where(inf_status: nil, pathologist_id: current_user.id).or(Inform.where(inf_status: "revision_cyto", pathologist_id: current_user.id))
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(receive_date: date_range, inf_status: nil, pathologist_id: current_user.id).or(Inform.where(receive_date: date_range, inf_status: "revision_cyto", pathologist_id: current_user.id))
  end

  def descr_micros_cyto
    @tab = :cytologist
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: nil, cytologist: current_user.id)
    # else
    #   @informs = Inform.where(inf_status: nil, cytologist: current_user.id)
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(receive_date: date_range, inf_status: nil, cytologist: current_user.id)
  end

  def descr_micro
    @organs = Organ.all

    @automatics = []
    # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
    Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
      if @inform.inf_type == "cito"
        Automatic.where(auto_type: "cito", organ: sample.organ_code).each do |auto|
          @automatics << auto
        end
      else
        Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
          @automatics << auto
        end
      end
    end   

    # @samples = @inform.samples

    # @samplesc = @inform.samples.where(name: "Cassette")

    # @blocks = @inform.blocks
  end

  def edit_micro
    
  end

  def set_revision
    if @inform.inf_type == 'cito'
      if @inform.pathologist_id == nil && @inform.cytologist != nil
        @inform.update(inf_status: "revision_cyto")
        redirect_to descr_micros_cyto_informs_path
      end
      if @inform.pathologist_id != nil
        @inform.update(inf_status: "revision")
        redirect_to descr_micros_informs_path
      end
    else
      @inform.update(inf_status: "revision")
      redirect_to descr_micros_informs_path
    end
  end

  def clear_revision
    @inform.update(inf_status: nil, pathologist_review_id: nil, administrative_review_id: nil)

    redirect_to descr_micro_inform_path(@inform)
  end

  def set_ready
    
    if Role.where(id: current_user.role_id).first.name == "Patologia"
      @inform.update(user_review_date: Date.today, pathologist_review_id: current_user.id)
    elsif Role.where(id: current_user.role_id).first.name == "CTO"
      @inform.update(user_review_date: Date.today, pathologist_review_id: current_user.id)
      @inform.update(user_review_date: Date.today, administrative_review_id: current_user.id)
    elsif Role.where(id: current_user.role_id).first.name == "Secretaria"
      @inform.update(user_review_date: Date.today, administrative_review_id: current_user.id)
    elsif Role.where(id: current_user.role_id).first.name == "Jefatura de laboratorio"
      @inform.update(user_review_date: Date.today, administrative_review_id: current_user.id)
    end
    
    # if @inform.pathologist_review_id != nil && @inform.administrative_review_id != nil
    #   @inform.update(inf_status: "ready")
    # end
    if @inform.pathologist_review_id != nil
      @inform.update(inf_status: "ready", delivery_date: Time.now) #Esta opcion implica solo revision de patologo y queda READY
    end

    redirect_to index_revision_informs_path
  end

  def distribution
    @tab = :asign
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   # @informs = Inform.where(created_at: date_range).joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    # else
    #   # @informs = Inform.joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true).joins(:inform).select("slides.inform_id").distinct
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    @informs = []
    @informs_unassigned = []
    @informs_first_batch = []
    @informs_rest = []
    @slides.each do |slide|
      if slide.inform.slides.count == slide.inform.slides.where(colored: true, covered: true, tagged: true).count
        if slide.inform.inf_type != 'cito'
          unless slide.inform.inf_status == "ready" || slide.inform.inf_status == "published" || slide.inform.inf_status == "downloaded"
            if slide.inform.pathologist_id != nil
              @informs << slide.inform
            else
              @informs_unassigned << slide.inform
            end
          end
        end
      end
    end
    # @informs_unassigned.each_with_index do |inform, n|
    #   if n <=50
    #     @informs_first_batch << inform
    #   else
    #     @informs_rest << inform
    #   end
    # end
    @informs_first_batch = @informs_unassigned[0..49]
    if @informs_first_batch == nil
      @informs_unassigned = []
    end
    @informs_rest = @informs_unassigned[50..-1]
    if @informs_rest == nil
      @informs_rest = []
    end

    @informs2 = []
    @informs2_unassigned = []
    @informs2_first_batch = []
    @informs2_rest = []
    @slides.each do |slide|
      if slide.inform.slides.count == slide.inform.slides.where(colored: true, covered: true, tagged: true).count
        if slide.inform.inf_type == 'cito'
          unless slide.inform.inf_status == "ready" || slide.inform.inf_status == "published" || slide.inform.inf_status == "downloaded" || slide.inform.inf_status == "revision"
            # @informs2 << slide.inform
            if slide.inform.pathologist_id != nil
              @informs2 << slide.inform # citos ya asignadas en otro batch, van directo a @informs porque ya tienen patologo/a
            else
              @informs2_unassigned << slide.inform
            end
          end
        end
      end
    end

    @already_negative = 0
    @negative_cytos = []
    @informs3_unassigned = []   #Aca solo almaceno las positivas e instatisfactorias. No las saco del arreglo original para no lidiar con offsets
    if @informs2_unassigned != nil
      @informs2_unassigned.each do |inform|
        if inform.diagnostics != []
          if inform.diagnostics.first.result != nil
            if inform.diagnostics.first.result == 'positiva'
              @informs3_unassigned << inform
            end
            if inform.diagnostics.first.result == 'insatisfactoria'
              @informs3_unassigned << inform
            end
            if inform.diagnostics.first.result == 'negativa'
              if inform.pathologist_id != nil
                @informs2 << inform
                @already_negative = @already_negative + 1
              else
                @negative_cytos << inform
              end
              
            end
          end
        end
      end
      proportion = 0.1
      negative_pick = (@negative_cytos.count * proportion).ceil  #Obtengo el 10% round up de las negativas

      if @already_negative < negative_pick
        negative_pick.times do
          n = rand(1..@negative_cytos.length) - 1
          while @informs.last == @negative_cytos[n]
            n = rand(1..@negative_cytos.length) - 1 #No es posible repetir numero
          end
          @informs3_unassigned << @negative_cytos[n]
          @negative_cytos.delete_at(n)
        end
      end
    end

    @informs2_first_batch = @informs3_unassigned[0..49]
    if @informs2_first_batch == nil
      @informs_unassigned = []
    end
    @informs2_rest = @informs3_unassigned[50..-1]
    if @informs2_rest == nil
      @informs2_rest = []
    end

    @negative_cytos.each do |inform|
      inform.update(inf_status: "revision") #Se deben marcar como para validación
    end
    pathologist_role_id = Role.where(name: "Patologia").first.id
    @users = User.where(role_id: pathologist_role_id)

    # @informs_assigned = @informs.where.not(pathologist_id: nil)
    # @informs_unassigned = @informs.where(pathologist_id: nil)
    # @informs_first_batch = @informs_unassigned.limit(50)
    # @informs_rest = @informs_unassigned.offset(50)
  end

  def distribution_cyto
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   # @informs = Inform.where(created_at: date_range).joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    # else
    #   # @informs = Inform.joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true).joins(:inform).select("slides.inform_id").distinct
    # end
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct

    @informs = []
    @informs_unassigned = []
    @informs_first_batch = []
    @informs_rest = []
    @slides.each do |slide|
      if slide.inform.slides.count == slide.inform.slides.where(colored: true, covered: true, tagged: true).count
        if slide.inform.cytologist != nil
          @informs << slide.inform
        else
          @informs_unassigned << slide.inform
        end
      end
      @informs_first_batch = @informs_unassigned[0..49]
      if @informs_first_batch == nil
        @informs_first_batch = []
      end
      @informs_rest = @informs_unassigned[50..-1]
      if @informs_rest == nil
        @informs_rest = []
      end
    end
    
    cytologist_role_id = Role.where(name: "Citologia").first.id
    @users = User.where(role_id: cytologist_role_id)

    # @informs_assigned = @informs.where.not(cytologist: nil)
    # @informs_unassigned = @informs.where(cytologist: nil)
    # @informs_first_batch = @informs_unassigned.limit(50)
    # @informs_rest = @informs_unassigned.offset(50)
  end

  def assign
    Inform.where(id: params[:inform_ids]).update_all({pathologist_id: params[:pathologist_id].to_i == 0 ? nil : params[:pathologist_id].to_i })

    # if params[:yi] != ""
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
      
    #   redirect_to distribution_path + "?di=#{params[:di]}&mi=#{params[:mi]}&yi=#{params[:yi]}&df=#{params[:df]}&mf=#{params[:mf]}&yf=#{params[:yf]}"
    # else
    #   redirect_to distribution_path
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    redirect_to distribution_path + "?init_date=" + params[:init_date] + "&final_date=" + params[:final_date]
  end

  def assign_cyto
    Inform.where(id: params[:inform_ids]).update_all({cytologist: params[:cytologist].to_i == 0 ? nil : params[:cytologist].to_i })

    # if params[:yi] != ""
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
      
    #   redirect_to distribution_path + "?di=#{params[:di]}&mi=#{params[:mi]}&yi=#{params[:yi]}&df=#{params[:df]}&mf=#{params[:mf]}&yf=#{params[:yf]}"
    # else
    #   redirect_to distribution_cyto_path
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    redirect_to distribution_cyto_path + "?init_date=" + params[:init_date] + "&final_date=" + params[:final_date]
  end

  # GET /informs/1
  # GET /informs/1.json
  def show
    @organs = Organ.all

    @automatics = Automatic.all
    @automatics_macro = Automatic.where(auto_type: "macro")
    @automatics_micro = Automatic.where(auto_type: "micro")


    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks

    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end

    if @inform.inf_type == 'cito'
      @cytologies = @inform.cytologies
    end
  end

  def show_revision
    @organs = Organ.all

    @automatics = Automatic.all
    @automatics_macro = Automatic.where(auto_type: "macro")
    @automatics_micro = Automatic.where(auto_type: "micro")


    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks

    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end

    if @inform.inf_type == 'cito'
      @cytologies = @inform.cytologies
    end
  end

  def autos_micro
    @organs = Organ.all

    @automatics = []
    # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
    Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
      Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
        @automatics << auto
      end
    end 
  end

  # GET /informs/new
  def new
    @inform = Inform.new
    @physician = @inform.physicians.build
  end

  # GET /informs/1/edit
  def edit
    @promoters = Promoter.where(enabled: true)
    @promoters.each do |promoter|
      promoter.initials = promoter.regime[0] + "-" + promoter.initials
    end
    @promoters = @promoters.pluck(:initials, :id)

    @municipalities = Municipality.all
    @municipalities.each do |municipality|
      municipality.municipality = municipality.municipality + " - " + municipality.department[0..2]
    end
  end

  def create
    inform = Inform.new(inform_params)
    inform.patient_id = params[:inform][:patient_id]
    # inform = @patient.informs.build(inform_params)
    inform.user_id = current_user.id
  

    entity = Branch.where(id: inform.branch_id).first.entity
    if entity == nil
      inform.entity_id = nil
    else
      inform.entity_id = entity.id
    end  
    
    inform.regime = Promoter.where(id: inform.promoter_id).first.try(:regime)

    date_range = Date.today.beginning_of_year..Date.today.end_of_year

    if params[:inform][:inf_type] == "clin"
       consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1
       inform.tag_code = "C" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
    else
     if params[:inform][:inf_type] == "hosp"
       consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1
       inform.tag_code = "H" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
     else
       consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1
       inform.tag_code = "K" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
     end
    end

    if inform.save
      redirect_to inform, notice: 'Informe exitosamente creado.'
    else
      render :new
    end
  end

  # PATCH/PUT /informs/1
  # PATCH/PUT /informs/1.json
  def update
    # @inform.branch_id = inform_params[:branch_id]
    # @inform.entity_id = Branch.find(inform_params[:branch_id]).entity.id
    # @inform.save
    @inform.update(inform_params)
    @inform.update(entity_id: Branch.find(inform_params[:branch_id]).entity.id)

    if @inform.inf_status == "revision"
      redirect_to show_revision_inform_path(@inform), notice: 'Informe exitosamente actualizado.'
    else
      redirect_to @inform, notice: 'Informe exitosamente actualizado.'
    end
    
  end

  # DELETE /informs/1
  # DELETE /informs/1.json
  def destroy
    @inform.destroy
    respond_to do |format|
      format.html { redirect_to informs_url, notice: 'Informe exitosamente borrado.' }
      format.json { head :no_content }
    end
  end

  def anulate
    if @inform.inf_status == "anulado"
      @inform.update(inf_status: nil, user_id: current_user.id)
      objection = @inform.objections.build(
          user_id: current_user.id,
          obcode_id: 22,
          responsible_user_id: @inform.user_id,
          description: "Se restaura informe. Fecha: " + DateTime.now.to_s

        )
    else
      @inform.update(inf_status: "anulado", user_id: current_user.id)
      objection = @inform.objections.build(
          user_id: current_user.id,
          obcode_id: 22,
          responsible_user_id: @inform.user_id,
          description: "Se anula informe. Fecha: " + DateTime.now.to_s

        )
    end
    objection.save
    
    redirect_to informs_url, notice: 'Informe exitosamente anulado.'
  end

  def preview
    if @inform.inf_type != 'cito'
      @pathologists = []

      @micro_text = ""
      @inform.micros.each do |micro|
        if micro.description.size > 500
          @micro_text = @micro_text + "\n" + "\n" + micro.description + "\n "
        else
          @micro_text = @micro_text + micro.description + " "  
        end
        
      end

      @diagnostic_text = ""
      @inform.diagnostics.each do |diagnostic|
        @pathologists << User.where(id: diagnostic.user_id).first
        @diagnostic_text = @diagnostic_text + diagnostic.description + " "
      end
      @pathologists = @pathologists.uniq
      
    else
      @pathologists = []

      if @inform.diagnostics != []
        diagnostic = @inform.diagnostics.last
        @pathologists << User.where(id: diagnostic.user_id).first
        @pathologists = @pathologists.uniq
      else
        diagnostic = nil
        @pathologists = []
      end
      
      @cytologist = User.where(id: @inform.cytologist).first

      if @inform.cytologies != []
        @cytology = @inform.cytologies.first
      else
        @cytology = nil
      end
      

    end
    

  end

  # private
    def clasify_templates

    end
    # Use callbacks to share common setup or constraints between actions.
    def set_inform
      @inform = Inform.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inform_params
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, :p_age, :p_age_type, :p_address, :p_email, :p_tel, :p_cel, :p_occupation, :p_residence_code, :p_municipality, :p_department, :inf_type, :cytologist, cytologies_attributes: [:id, :inform_id, :pregnancies, :last_mens, :prev_appo, :sample_date, :last_result, :birth_control, :user_id, :suggestion], physicians_attributes: [:id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] )
    end
end
