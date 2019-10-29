class InformsController < ApplicationController
  before_action :set_inform, only: [:show, :edit, :update, :destroy]

  # GET /informs
  # GET /informs.json
  def index
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(created_at: date_range)
    else
      if !params[:filter].blank?
        @informs = Inform.where(tag_code: params[:filter])
      else
        @informs = Inform.all
      end
    end
  end

  # GET /informs/1
  # GET /informs/1.json
  def show
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

      inform.tag_code = 'C' + Date.today.strftime('%y').to_s + '-' + inform.id.to_s
      inform.save #Just after saving is when I get de ID, and its needed for the serial code...
      redirect_to @patient, notice: 'Inform was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /informs/1
  # PATCH/PUT /informs/1.json
  def update
    respond_to do |format|
      if @inform.update(inform_params)
        format.html { redirect_to @inform, notice: 'Inform was successfully updated.' }
        format.json { render :show, status: :ok, location: @inform }
      else
        format.html { render :edit }
        format.json { render json: @inform.errors, status: :unprocessable_entity }
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inform
      @inform = Inform.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inform_params
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, physicians_attributes: [:id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] )
    end
end
