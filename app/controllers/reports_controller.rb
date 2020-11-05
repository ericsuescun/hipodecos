class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    
  end

  def status
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(created_at: date_range)
    else
      @informs = Inform.all
    end
  end

  def objections
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @objections = Objection.where(created_at: date_range)

      @obj_physicians = @objections.where(objectionable_type: 'Physician')
      @obj_samples = @objections.where(objectionable_type: 'Sample')
      @obj_studies = @objections.where(objectionable_type: 'Study')
      @obj_blocks = @objections.where(objectionable_type: 'Block')
      @obj_slides = @objections.where(objectionable_type: 'Slide')
      @obj_macros = @objections.where(objectionable_type: 'Macro')
      @obj_micros = @objections.where(objectionable_type: 'Micro')
      @obj_diagnostics = @objections.where(objectionable_type: 'Diagnostic')
    else
      @objections = Objection.all

      @obj_physicians = @objections.where(objectionable_type: 'Physician')
      @obj_samples = @objections.where(objectionable_type: 'Sample')
      @obj_studies = @objections.where(objectionable_type: 'Study')
      @obj_blocks = @objections.where(objectionable_type: 'Block')
      @obj_slides = @objections.where(objectionable_type: 'Slide')
      @obj_macros = @objections.where(objectionable_type: 'Macro')
      @obj_micros = @objections.where(objectionable_type: 'Micro')
      @obj_diagnostics = @objections.where(objectionable_type: 'Diagnostic')
    end
  end

  def sales
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @branches = Branch.all
      @informs = Inform.where(created_at: date_range)
    else
      @branches = Branch.all
    end
  end

  def sales2
    @tab = :sales
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date

      @total_entities = []
      @total_detail = []
      @branch_detail = []
      @total_accumulated = 0
      Entity.all.each do |entity|
        @total_detail << [ entity, "", "++", "--", 0, 0, 0, 0 ]
        @price = 0
        @total_branch = []
        entity.branches.each do |branch|
          @partial = 0
          Inform.where(receive_date: date_range, branch_id: branch.id).each do |inform|
            inform.studies.each do |study|
              @price += study.price * study.factor
              @partial += study.price * study.factor
              @total_detail << [ entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price ]
            end
          end
          @total_detail << [ entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
        end
        @total_detail << [ entity.name, "--", "--", "--", 0, 0, 0, @price ]

        @total_entities << [ entity.id, @price ]
        @total_accumulated += @price
      end
      

    else
      initial_date = Date.today.beginning_of_month
      final_date = Date.today.end_of_month
      date_range = initial_date..final_date

      @total_entities = []
      @total_detail = []
      Entity.all.each do |entity|
        @price = 0
        entity.branches.each do |branch|
          @partial = 0
          Inform.where(receive_date: date_range, branch_id: branch.id).each do |inform|
            inform.studies.each do |study|
              @price += study.price * study.factor
              @partial += study.price * study.factor
              @total_detail << [ entity.name, branch.name, inform, study.price, study.factor, study.price * study.factor, @price ]
            end
          end
        end
        @total_entities << [ entity.id, @price ]
      end
    end
    
  end

  def show
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @total_entities = []
    @total_detail = []
    @branch_detail = []
    @total_accumulated = 0
    @price = 0
    @total_branch = []
    @entity.branches.each do |branch|
      @partial = 0
      Inform.where(receive_date: date_range, branch_id: branch.id).each do |inform|
        inform.studies.each do |study|
          @price += study.price * study.factor
          @partial += study.price * study.factor
          @total_detail << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price ]
        end
      end
      @total_detail << [ @entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
    end
    @total_detail << [ @entity.name, "--", "--", "--", 0, 0, 0, @price ]

    @total_entities << [ @entity.id, @price ]
    @total_accumulated += @price
  end

  def reports_params_today
  end

end
