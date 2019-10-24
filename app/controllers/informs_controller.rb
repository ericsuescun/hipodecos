class InformsController < ApplicationController
  before_action :set_inform, only: [:show, :edit, :update, :destroy]

  # GET /informs
  # GET /informs.json
  def index
    if params[:filter].blank?    
      if params[:tag_code].blank?
        @informs = Inform.all
      else
        @informs = Inform.where(tag_code: params[:tag_code])
      end
    else
      if params[:filter] == 'hoy'
        @informs = Inform.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
      else
        if params[:filter] == 'ayer'
          @informs = Inform.where(created_at: (Date.today - 1).beginning_of_day..(Date.today - 1).end_of_day)
        else
          if params[:filter] == 'antier'
            @informs = Inform.where(created_at: (Date.today - 2).beginning_of_day..(Date.today - 2).end_of_day)
          else
            if params[:filter] == 'trasantier'
              @informs = Inform.where(created_at: (Date.today - 3).beginning_of_day..(Date.today - 3).end_of_day)
            else
              if params[:filter] == 'semana'
                @informs = Inform.where(created_at: (Date.today - 7).beginning_of_day..Date.today.end_of_day)
              else
                if params[:filter] == 'mes'
                  @informs = Inform.where(created_at: (Date.today - 30).beginning_of_day..Date.today.end_of_day)
                end
              end
            end
          end
        end
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
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice )
    end
end
