class ReportsController < ApplicationController
  before_action :authenticate_user!

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

  def billings
    @tab = :billing
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = Date.today.beginning_of_month
      final_date = Date.today.end_of_month
      date_range = initial_date..final_date
    end

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
        Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, branch_id: branch.id, invoice: "").each do |inform|
          @inform_partial = 0
          @inform_studies = []
          inform.studies.each do |study|
            @price += study.price * study.factor
            @partial += study.price * study.factor
            @inform_partial += study.price * study.factor
            @inform_studies << study
          end
          @total_detail << [ entity.name, branch.name, inform, @inform_studies, 0, 0, @inform_partial, @price ]
        end
        @total_detail << [ entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
      end
      @total_detail << [ entity.name, "--", "--", "--", 0, 0, 0, @price ]

      @total_entities << [ entity.id, @price ]
      @total_accumulated += @price
    end
  end

  def sales
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
          Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, branch_id: branch.id).where.not(invoice: "")).each do |inform|
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
          Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, branch_id: branch.id).where.not(invoice: "")).each do |inform|
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

  def show_billing
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
      Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id, invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id, invoice: "")).each do |inform|
        @inform_studies = []
        @inform_partial = 0
        inform.studies.each do |study|
          @price += study.price * study.factor
          @partial += study.price * study.factor
          @inform_partial += study.price * study.factor
          #@total_detail << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price ]
          @inform_studies << study
        end
        @total_detail << [ @entity.name, branch.name, inform, @inform_studies, 0, 0, @inform_partial, @price ]
      end
      @total_detail << [ @entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
    end
    @total_detail << [ @entity.name, "--", "--", "--", 0, 0, 0, @price ]

    @total_entities << [ @entity.id, @price ]
    @total_accumulated += @price
  end

  def invoice
    # @entity = Entity.find(params[:id])
    # initial_date = Date.parse(params[:init_date]).beginning_of_day
    # final_date = Date.parse(params[:final_date]).end_of_day
    # date_range = initial_date..final_date
    # @informs = Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: params[:id], invoice: "")
    # @informs.update_all(invoice: params[:info])
    
    # redirect_to show_sale_report_path + "?init_date=" + params[:init_date] + "&final_date=" + params[:final_date] + "&inf_type=" + params[:inf_type]
  end

  def show_sale
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
      Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        @inform_studies = []
        @inform_partial = 0
        inform.studies.each do |study|
          @price += study.price * study.factor
          @partial += study.price * study.factor
          @inform_partial += study.price * study.factor
          #@total_detail << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price ]
          @inform_studies << study
        end
        @total_detail << [ @entity.name, branch.name, inform, @inform_studies, 0, 0, @inform_partial, @price ]
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
