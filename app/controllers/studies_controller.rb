class StudiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_study, only: [:show, :edit, :update, :destroy]

  # GET /studies
  # GET /studies.json
  def index
    @studies = Study.all
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @inform = @study.inform
    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end
  end

  # GET /studies/new
  def new
    @study = Study.new
  end

  # GET /studies/1/edit
  def edit
    @inform = @study.inform
    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end
  end

  # POST /studies
  # POST /studies.json
  def create
    inform = Inform.find(params[:inform_id])
    @study = inform.studies.build(study_params)
    @study.user_id = current_user.id

    branch = Branch.find(inform.branch_id)
    entity = branch.entity

    @study.cost = Value.where(codeval_id: @study.codeval_id, cost_id: branch.entity.cost_id).first.value
    profit_margin = Factor.where(codeval_id: @study.codeval_id, rate_id: branch.entity.rate_id).first.factor
    @study.price =  @study.cost * profit_margin
    @study.margin =  @study.cost * (profit_margin - 1)

    cost_description = Cost.where(id: branch.entity.cost_id).first.try(:name)
    value_description = Value.where(codeval_id: @study.codeval_id, cost_id: branch.entity.cost_id).first.try(:description)
    rate_description = Rate.where(id: branch.entity.rate_id).first.try(:name)
    factor_description = Factor.where(codeval_id: @study.codeval_id, rate_id: branch.entity.rate_id).first.try(:description)

    @study.price_description = cost_description + ". " + rate_description + ". Notas costo: " + value_description + ". Notas factor: " + factor_description

    @inform = @study.inform

    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end

    @study.save
  end

  # PATCH/PUT /studies/1
  # PATCH/PUT /studies/1.json
  def update

    log = "\nCAMBIOS:\n"
    if @study.codeval_id != study_params[:codeval_id]
      log += "\n-CUPS-\nANTES:" + Codeval.find(@study.codeval_id).code.to_s + "\n- DESPUÉS: -\n" + Codeval.find(study_params[:codeval_id]).code.to_s
    else
      log += "\n-CUPS-\nSIN CAMBIOS."
    end
    if @study.factor != study_params[:factor]
      log += "\n-FACTOR-\nANTES:" + @study.factor.to_s + "\n- DESPUÉS: -\n" + study_params[:factor].to_s
    else
      log += "\n-FACTOR-\nSIN CAMBIOS."
    end
    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s

    @inform = @study.inform
    
    @study.update(study_params)
    @study.objections.each do |objection|
      objection.closed = true
      objection.close_user_id = current_user.id
      objection.close_date = @study.updated_at
      objection.description = objection.description + log
      objection.save
    end
    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    @inform = @study.inform
    @study.destroy

    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study
      @study = Study.find(params[:id])
      @inf = @study.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_params
      params.require(:study).permit(:inform_id, :user_id, :codeval_id, :factor)
    end
end
