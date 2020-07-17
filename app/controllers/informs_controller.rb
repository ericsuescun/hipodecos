class InformsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inform, only: [:show, :show_revision, :edit, :update, :destroy, :preview, :descr_micro, :clear_revision, :set_revision, :set_ready]

  # GET /informs
  # GET /informs.json
  def index
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(receive_date: date_range, inf_type: params[:inf_type])
    else
      if !params[:tag_code].blank?
        @informs = Inform.all
      else
        @informs = Inform.all
      end
    end
  end

  def last20
    @informs = Inform.all.limit(20)
    # @informs = []
  end

  def index_revision
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(receive_date: date_range, inf_status: "revision")
    else
      @informs = Inform.where(inf_status: "revision")
    end
  end

  def index_ready
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(receive_date: date_range, inf_status: "ready")
    else
      @informs = Inform.where(inf_status: "ready")
    end
  end

  def descr_micros
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(receive_date: date_range, inf_status: nil, pathologist_id: current_user.id)
    else
      @informs = Inform.where(inf_status: nil, pathologist_id: current_user.id)
    end
  end

  def descr_micro
    @organs = Organ.all

    @automatics = []
    # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
    Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
      Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
        @automatics << auto
      end
    end   

    # @samples = @inform.samples

    # @samplesc = @inform.samples.where(name: "Cassette")

    # @blocks = @inform.blocks
  end

  def edit_micro
    
  end

  def set_revision
    @inform.update(inf_status: "revision")

    redirect_to descr_micros_informs_path
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
    elsif Role.where(id: current_user.role_id).first.name == "Secretaria"
      @inform.update(user_review_date: Date.today, administrative_review_id: current_user.id)
    elsif Role.where(id: current_user.role_id).first.name == "Jefatura de laboratorio"
      @inform.update(user_review_date: Date.today, administrative_review_id: current_user.id)
    end
    
    if @inform.pathologist_review_id != nil && @inform.administrative_review_id != nil
      @inform.update(inf_status: "ready")
    end

    redirect_to index_revision_informs_path
  end

  def distribution
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      # @informs = Inform.where(created_at: date_range).joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
      @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    else
      # @informs = Inform.joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
      @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true).joins(:inform).select("slides.inform_id").distinct
    end
  end

  def assign
    Inform.where(id: params[:inform_ids]).update_all({pathologist_id: params[:pathologist_id].to_i})

    if params[:yi] != ""
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      
      redirect_to distribution_path + "?di=#{params[:di]}&mi=#{params[:mi]}&yi=#{params[:yi]}&df=#{params[:df]}&mf=#{params[:mf]}&yf=#{params[:yf]}"
    else
      redirect_to distribution_path
    end
  end

  # GET /informs/1
  # GET /informs/1.json
  def show
    @organs = Organ.all

    # byebug

    @automatics = Automatic.all
    @automatics_macro = Automatic.where(auto_type: "macro")
    @automatics_micro = Automatic.where(auto_type: "micro")


    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks

    if @inform.inf_type == 'cito'
      @cytologies = @inform.cytologies
    end
  end

  def show_revision
    
  end

  # GET /informs/new
  def new
    @inform = Inform.new
    @physician = @inform.physicians.build
  end

  # GET /informs/1/edit
  def edit
  end

  def create
    inform = Inform.new(inform_params)
    inform.patient_id = params[:inform][:patient_id]
    # inform = @patient.informs.build(inform_params)
    inform.user_id = current_user.id
    
    # byebug

    entity = Branch.where(id: inform.branch_id).first
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
      redirect_to inform, notice: 'Inform was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /informs/1
  # PATCH/PUT /informs/1.json
  def update
    if @inform.update(inform_params)
      redirect_to @inform, notice: 'Inform was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /informs/1
  # DELETE /informs/1.json
  def destroy
    @inform.destroy
    respond_to do |format|
      format.html { redirect_to informs_url, notice: 'Inform was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def preview
    @pathologists = []
    @inform.diagnostics.each do |diagnostic|
      @pathologists << User.where(id: diagnostic.user_id).first
    end
    @pathologists = @pathologists.uniq

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
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, :p_age, :p_age_type, :p_address, :p_email, :p_tel, :p_cel, :p_occupation, :p_residence_code, :p_municipality, :p_department, :inf_type, physicians_attributes: [:id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] )
    end
end
