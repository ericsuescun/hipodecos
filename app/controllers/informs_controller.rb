class InformsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inform, only: [:show, :edit, :update, :destroy, :preview, :descr_micro]

  # GET /informs
  # GET /informs.json
  def index
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(receive_date: date_range)
    else
      if !params[:tag_code].blank?
        @informs = Inform.where(tag_code: params[:tag_code])
      else
        @informs = Inform.all
      end
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

    @automatics = Automatic.all

    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks
  end

  def distribution
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      # @informs = Inform.where(created_at: date_range).joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
      @slides = Slide.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("inform_id").distinct
    else
      # @informs = Inform.joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
      @slides = Slide.where(colored: true, covered: true, tagged: true).joins(:inform).select("inform_id").distinct
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

    @automatics = Automatic.all

    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks

    # clasify_templates
  end

  # GET /informs/new
  def new
    @inform = Inform.new
    @physician = @inform.physicians.build
  end

  # GET /informs/1/edit
  def edit
  end

  # POST /informs
  # POST /informs.json
  def create
    # @inform = Inform.new(inform_params)
    @patient = Patient.find(params[:patient_id])
    inform = @patient.informs.build(inform_params)
    inform.user_id = current_user.id
    if @patient.sex == 'M'
      inform.pregnancy_status = '4'
    end
    inform.entity_id = Branch.find(inform.branch_id).entity.id

    if inform.save

      if !params[:inform][:physician].blank?
        pnew = Physician.new
        pnew.name = params[:inform][:physician][:name]
        pnew.lastname = params[:inform][:physician][:lastname]
        pnew.tel = params[:inform][:physician][:tel]
        pnew.cel = params[:inform][:physician][:cel]
        pnew.email = params[:inform][:physician][:email]
        pnew.study1 = params[:inform][:physician][:study1]
        pnew.study2 = params[:inform][:physician][:study2]
        pnew.inform_id = inform.id
        pnew.user_id = current_user.id
        pnew.save
      end
      
      date_range = Date.today.beginning_of_year..Date.today.end_of_year
      finf = Inform.where(created_at: date_range).last #Traingo el primer informe de año en curso. Last sería el primero desde que traigo ordenado por fecha y los más recientes son los primeros, mientras que los más viejos son los últimos. IMPORTANTE: El orden en el modelo es DESCENDENTE sobre el parámetro CREATED_AT. NO FUNCIONA BIEN si no es con ese parámetro. Los id van en el orden de creación!
      inform.regime = Promoter.where(id: inform.promoter_id).first.try(:regime)
      inform.tag_code = 'C' + Date.today.strftime('%y').to_s + '-' + (inform.id - finf.id + 1).to_s #Para aplicar el consecutivo, tomo el id del registro actual, le resto el del primero del año y le sumo 1. Si coinciden, es decir, estoy justo en el primer registro del año, la resta dará 0, y el consecutivo asignado será 1 ! Esto además tiene en cuenta todos los registros pues esta basado en el id.
      inform.save #Just after saving is when I get de ID, and its needed for the serial code...
      redirect_to @patient, notice: 'Inform was successfully created.'
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
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, physicians_attributes: [:id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] )
    end
end
