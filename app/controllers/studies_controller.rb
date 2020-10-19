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

    @study.cost = Value.where(codeval_id: @study.codeval_id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.value
    # profit_margin = Factor.where(codeval_id: @study.codeval_id, rate_id: branch.entity.rate_id).first.factor
    # @study.price =  @study.cost * profit_margin
    @study.price =  Factor.where(codeval_id: @study.codeval_id, rate_id: branch.entity.rate_id).first.price
    # @study.margin =  @study.cost * (profit_margin - 1)
    @study.margin =  @study.price - @study.cost

    cost_description = Cost.where(id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:name)
    value_description = Value.where(codeval_id: @study.codeval_id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:description)
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
    @inform = @study.inform
        
    @study.user_id = current_user.id

    branch = Branch.find(@inform.branch_id)
    entity = branch.entity

    @study.cost = Value.where(codeval_id: params[:study][:codeval_id], cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.value
    @study.price =  Factor.where(codeval_id: params[:study][:codeval_id], rate_id: branch.entity.rate_id).first.price
    @study.margin =  @study.price - @study.cost
    @study.factor = params[:study][:factor]
    @study.codeval_id = params[:study][:codeval_id]

    cost_description = Cost.where(id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:name)
    value_description = Value.where(codeval_id: params[:study][:codeval_id], cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:description)
    rate_description = Rate.where(id: branch.entity.rate_id).first.try(:name)
    factor_description = Factor.where(codeval_id: params[:study][:codeval_id], rate_id: branch.entity.rate_id).first.try(:description)

    @study.price_description = cost_description + ". " + rate_description + ". Notas costo: " + value_description + ". Notas factor: " + factor_description

    @study.save

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
