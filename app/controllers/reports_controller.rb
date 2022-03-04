class ReportsController < ApplicationController
  before_action :authenticate_user!

  def cancer_report
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = Date.today.beginning_of_month
      final_date = Date.today.end_of_month
      date_range = initial_date..final_date
    end

    # diagnostics = Diagnostic.joins(:inform).where(informs: { delivery_date: date_range, inf_status: "published"}).joins(:diagcode).where(diagcodes: { cancer: true  })
    diagnostics = Diagnostic.joins(:inform).where(informs: { delivery_date: date_range, inf_status: "published", inf_type: "clin" })
    diag = []
    diagnostics.map do |diagnostic|
      if diagnostic.diagcode_id.present?
        diag << diagnostic if Diagcode.where(id: diagnostic.diagcode_id).take.cancer 
      end
    end

    @informs = []
    @informs = diag.map { |diagnostic| diagnostic.inform }.uniq.sort_by {|inform| inform[:consecutive]} if diagnostics.present?
  end

  def branch_report
    @branch_id = params[:branch_id]
    inf_type = params[:inf_type]
    @informs = Inform.where(inf_type: inf_type, branch_id: @branch_id, delivery_date: date_range).publ_down.order(consecutive: :asc)
  end

  def branch_index
    @branches = Branch.all
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
      Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id, invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id, invoice: "")).order(consecutive: :asc).each do |inform|
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
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date
    @informs = Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: params[:id], invoice: "").or(@informs = Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: params[:id], invoice: ""))
    @informs.update_all(invoice: params[:invoice], invoice_date: params[:invoice_date])
    @invoice = Invoice.create(
        invoice_code: params[:invoice],
        init_date: Date.parse(params[:init_date]),
        final_date: Date.parse(params[:final_date]),
        invoice_date: Date.parse(params[:invoice_date]),
        entity_id: params[:id],
        inf_type: params[:inf_type],
        value: params[:value].to_f,
        user_id: current_user.id
      )

    redirect_to show_sale_report_path + "?init_date=" + params[:init_date] + "&final_date=" + params[:final_date] + "&inf_type=" + params[:inf_type]
  end

  def show_sale
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @total_entities = []
    @total_detail = []
    @total_affinity = []
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
      @total_affinity << [ @entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
    end
    @total_detail << [ @entity.name, "--", "--", "--", 0, 0, 0, @price ]

    @total_entities << [ @entity.id, @price ]
    @total_accumulated += @price
  end

  def show_branch
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @total_entities = []
    @total_detail = []
    @total_affinity = []
    @branch_detail = []
    @total_accumulated = 0
    @price = 0
    @total_branch = []

    if params[:branch_name] != nil
      branch = Branch.where(name: params[:branch_name]).first
      @partial = 0
      Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).order(consecutive: :asc).each do |inform|
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
    else
      @entity.branches.each do |branch|
        @partial = 0
        Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).order(consecutive: :asc).each do |inform|
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
        @total_affinity << [ @entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
      end
      @total_detail << [ @entity.name, "--", "--", "--", 0, 0, 0, @price ]

      @total_entities << [ @entity.id, @price ]
      @total_accumulated += @price
    end
  end

  def show_rips
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @total_detail = []
    @total_users = []
    @total_accumulated = 0
    @price = 0
    @entity.branches.each do |branch|
      Inform.where(inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        @total_users << [ inform.patient.id_type, inform.patient.id_number, "000000", regime(inform), inform.patient.lastname1, inform.patient.lastname2, inform.patient.name1, inform.patient.name2, inform.p_age, inform.p_age_type == "A" ? "1" : inform.p_age_type == "M" ? "2" : "3", inform.patient.sex, inform.p_municipality[0..1], inform.p_municipality[2..4], inform.zone_type ]
        inform.studies.each do |study|
          @price += study.price * study.factor
          @total_detail << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price ]
        end
      end
    end
    @total_accumulated += @price
    @total_users = @total_users.uniq

    @total_detail_clin = []
    @total_users_clin = []
    @total_accumulated_clin = 0
    @price_clin = 0
    @entity.branches.each do |branch|
      Inform.where(inf_type: "clin", inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        @total_users_clin << [ inform.patient.id_type, inform.patient.id_number, "000000", regime(inform), inform.patient.lastname1, inform.patient.lastname2, inform.patient.name1, inform.patient.name2, inform.p_age, inform.p_age_type == "A" ? "1" : inform.p_age_type == "M" ? "2" : "3", inform.patient.sex, inform.p_municipality[0..1], inform.p_municipality[2..4], inform.zone_type ]
        inform.studies.each do |study|
          @price_clin += study.price * study.factor
          @total_detail_clin << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price_clin ]
        end
      end
    end
    @total_accumulated_clin += @price_clin
    @total_users_clin = @total_users_clin.uniq

    @total_detail_cito = []
    @total_users_cito = []
    @total_accumulated_cito = 0
    @price_cito = 0
    @entity.branches.each do |branch|
      Inform.where(inf_type: "cito", inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        @total_users_cito << [ inform.patient.id_type, inform.patient.id_number, "000000", regime(inform), inform.patient.lastname1, inform.patient.lastname2, inform.patient.name1, inform.patient.name2, inform.p_age, inform.p_age_type == "A" ? "1" : inform.p_age_type == "M" ? "2" : "3", inform.patient.sex, inform.p_municipality[0..1], inform.p_municipality[2..4], inform.zone_type ]
        inform.studies.each do |study|
          @price_cito += study.price * study.factor
          @total_detail_cito << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price_cito ]
        end
      end
    end
    @total_accumulated_cito += @price_cito
    @total_users_cito = @total_users_cito.uniq

    file = ""
    case params[:file]
    when "ad_file"
      if @total_detail_clin.size > 0
        file += @total_detail_clin.first[2].invoice + "," + "050011134601,02," + @total_users_clin.count.to_s + ",," + @total_accumulated_clin.to_i.to_s + "\r\n"
      end
      if @total_detail_cito.size > 0
        file += @total_detail_cito.first[2].invoice + "," + "050011134601,02," + @total_users_cito.count.to_s + ",," + @total_accumulated_cito.to_i.to_s + "\r\n"
      end
      filename = "AD" + 1.month.ago.strftime("%m%Y") + ".TXT"
      send_data file[0..-3], filename: filename, type: 'text/html; charset=utf-8'
    when "af_file"
      if @total_detail_clin.size > 0
        file += "050011134601,PATOLOGIA SUESCUN SAS,NI,900363326-8," + @total_detail_clin.first[2].invoice + "," + Date.today.strftime("%d/%m/%Y") + "," + Date.parse(params[:init_date]).strftime("%d/%m/%Y") + "," + Date.parse(params[:final_date]).strftime("%d/%m/%Y") + ",000000," + Entity.where(id: params[:id]).first.name.upcase + ",,CONTRIBUTIVO,,,,," + @total_accumulated_clin.to_i.to_s + "\r\n"
      end
      if @total_detail_cito.size > 0
        file += "050011134601,PATOLOGIA SUESCUN SAS,NI,900363326-8," + @total_detail_cito.first[2].invoice + "," + Date.today.strftime("%d/%m/%Y") + "," + Date.parse(params[:init_date]).strftime("%d/%m/%Y") + "," + Date.parse(params[:final_date]).strftime("%d/%m/%Y") + ",000000," + Entity.where(id: params[:id]).first.name.upcase + ",,CONTRIBUTIVO,,,,," + @total_accumulated_cito.to_i.to_s + "\r\n"
      end
      filename = "AF" + 1.month.ago.strftime("%m%Y") + ".TXT"
      send_data file[0..-3], filename: filename, type: 'text/html; charset=utf-8'
    when "ct_file"
      file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "US" + 1.month.ago.strftime("%m%Y") + "," + (@total_users_clin.count + @total_users_cito.count).to_s  + "\r\n"
      file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "AP" + 1.month.ago.strftime("%m%Y") + "," + (@total_detail.count).to_s + "\r\n"
      file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "AF" + 1.month.ago.strftime("%m%Y") + "," + count_invoices(@total_users_clin.count, @total_users_cito.count).to_s + "\r\n"
      file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "AD" + 1.month.ago.strftime("%m%Y") + "," + count_invoices(@total_users_clin.count, @total_users_cito.count).to_s + "\r\n"
      filename = "CT" + 1.month.ago.strftime("%m%Y") + ".TXT"
      send_data file[0..-3], filename: filename, type: 'text/html; charset=utf-8'
    end
    # filename = "CT" + 1.month.ago.strftime("%m%Y") + ".TXT"
    # send_data 'esto es una prueba', filename: filename, type: 'text/html; charset=utf-8'

  end

  def show_rips_ap
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @total_detail = ''
    @price = 0
    @entity.branches.each do |branch|
      Inform.where(inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        # @total_users << [ inform.patient.id_type, inform.patient.id_number, "000000", regime(inform), inform.patient.lastname1, inform.patient.lastname2, inform.patient.name1, inform.patient.name2, inform.p_age, inform.p_age_type == "A" ? "1" : inform.p_age_type == "M" ? "2" : "3", inform.patient.sex, inform.p_municipality[0..1], inform.p_municipality[2..4], inform.zone_type ]
        inform.studies.each do |study|
          @price = study.price * study.factor #Aca no acumulo el valor!
          @total_detail += inform.invoice + "," + "050011134601" + "," + inform.patient.id_type + "," + inform.patient.id_number + "," + inform.delivery_date.strftime("%d/%m/%Y") + "," + inform.prmtr_auth_code + "," + Codeval.where(id: study.codeval_id).first.code + "," + inform.status + "," + "1," + "," + "," + "," + "," + "," + @price.to_i.to_s + "\r\n"
        end
      end
    end
    filename = "AP" + 1.month.ago.strftime("%m%Y") + ".TXT"
    send_data @total_detail[0..-4], filename: filename, type: 'text/html; charset=utf-8'

  end

  def show_rips_us
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @total_users = []
    @price = 0
    @entity.branches.each do |branch|
      Inform.where(inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        @total_users << [ inform.patient.id_type, inform.patient.id_number, "000000", regime(inform), inform.patient.lastname1.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase, inform.patient.lastname2.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase, inform.patient.name1.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase, inform.patient.name2.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase, inform.p_age, inform.p_age_type == "A" ? "1" : inform.p_age_type == "M" ? "2" : "3", inform.patient.sex, inform.p_municipality[0..1], inform.p_municipality[2..4], inform.zone_type ]
      end
    end
    @total_users = @total_users.uniq  #Purgo los repetidos

    users = ""

    @total_users.each do |user|
      users += user.join(",") + "\r\n"
    end

    filename = "US" + 1.month.ago.strftime("%m%Y") + ".TXT"
    send_data users[0..-3], filename: filename, type: 'text/html; charset=utf-8'
  end

  def show_affinity
    @entity = Entity.find(params[:id])
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    @invoice = ""
    @total_entities = []
    @total_detail = []
    @total_affinity_trans = []
    @branch_detail = []
    @total_accumulated = 0
    @price = 0
    @total_branch = []
    @entity.branches.each do |branch|
      @inform_studies = []
      @partial = 0
      Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|

        @inform_partial = 0
        @invoice = inform.invoice   #Queda con el valor de la última factura leída

        inform.studies.each do |study|
          @price += study.price * study.factor
          @partial += study.price * study.factor
          @inform_partial += study.price * study.factor
          #@total_detail << [ @entity.name, branch.name, inform, Codeval.where(id: study.codeval_id).first.code, study.price, study.factor, study.price * study.factor, @price ]
          study.factor.times do
            @inform_studies << study
          end

        end
        @total_detail << [ @entity.name, branch.name, inform, @inform_studies, 0, 0, @inform_partial, @price ]
      end
      @total_detail << [ @entity.name, branch.name, "**", "--", 0, 0, @partial, @price ]
      @total_affinity_trans << [ @entity.name, branch.name, @inform_studies, "--", 0, 0, @partial, @price ]
    end
    @total_detail << [ @entity.name, "--", "--", "--", 0, 0, 0, @price ]

    @total_entities << [ @entity.id, @price ]
    @total_accumulated += @price

    invoice_date = Invoice.where(invoice_code: @invoice).first.invoice_date
    offset = 0
    count = 0
    file = ""
    if params[:type] == "det"
      file += "ET,1000,1," + invoice_date.strftime("%Y-%m-%d") + ", , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,, , , , , , \r\n"
      file += "EB,1,8003, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,, , , , , , \r\n"
      @total_affinity_trans.each_with_index do |branch_data, n|
        if branch_data[6] != 0
          count += 1
          if params[:inf_type] == "clin"
            file += "RG," + count.to_s + ",0000," + invoice_date.strftime("%Y-%m-%d") + ",042," + @invoice + ",999999," + "ESTUDIOS PATOLOGICOS REALIZADOS A USUARIOS " + branch_data[1].to_s + ", , , , , , ,1,1," + branch_data[6].to_i.to_s + ",0,0,0,0,0,0,0,0,0, , , , , , ,0,0, , , , ,0,0,0\r\n"
          end
          if params[:inf_type] == "cito"
            file += "RG," + count.to_s + ",0000," + invoice_date.strftime("%Y-%m-%d") + ",042," + @invoice + ",898001," + "CITOLOGIA VAGINAL (Procesamiento y lectura)  USUARIAS " + branch_data[1].to_s + ", , , , , , ,#{branch_data[2].count},#{branch_data[2].count}," + Factor.where(codeval_id: 7, rate_id: @entity.rate_id).first.price.to_i.to_s + ",0,0,0,0,0,0,0,0,0, , , , , , ,0,0, , , , ,0,0,0\r\n"
          end
        else
          offset += 1
        end
      end
      file += "FB,1,8003," + (@total_affinity_trans.count - offset).to_s + ", , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,, , , , , , " + "\r\n"
      file += "FT,1000,1,1, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ,, , , , , , "

      filename = "detalle_#{params[:inf_type]}_" + @invoice + ".TXT"
      send_data file, filename: filename, type: 'text/html; charset=utf-8'
    end
    if params[:type] == "head"
      file += "ET,1000,1," + invoice_date.strftime("%Y-%m-%d") + ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n"
      file += "EB,1,8001,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n"
      file += "RG,1,0000," + invoice_date.strftime("%Y-%m-%d") + "," + @invoice + ",042,VTA03,11001," + @entity.tax_id + ",04, , ,Facturacion periodo " + Date.parse(params[:init_date]).strftime("%d/%m/%Y") + " a " + Date.parse(params[:final_date]).strftime("%d/%m/%Y") + ",,015,15,10,2,1,60,0,0," + @total_accumulated.to_i.to_s + ", , , , ,00,0, , ,N,P,0, ,0, ," + @total_accumulated.to_i.to_s + ", , , , , , , , , , ,S,S,10, , , , , \r\n"

      file += "FB,1,8001,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," + "\r\n"
      file += "FT,1000,1,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"

      filename = "enc_#{params[:inf_type]}_" + @invoice + ".TXT"
      send_data file, filename: filename, type: 'text/html; charset=utf-8'
    end

  end

  def daily_citos
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    entity = Entity.where(initials: params[:entity]).take if params[:entity].present?
    branches = entity.branches.ids if entity.present?
    date_range = initial_date..final_date
    @informs = Inform.where(delivery_date: date_range, inf_type: 'cito', branch_id: branches) if entity.present? || branches.present?
  end

  def stored_blocks
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date
    @blocks = Block.where(created_at: date_range, stored: true)
  end

  private

    def date_range
      date_range = nil
      if params[:init_date].present?
        initial_date = Date.parse(params[:init_date]).beginning_of_day
        final_date = Date.parse(params[:final_date]).end_of_day
        date_range = initial_date..final_date
      else
        initial_date = Date.today.beginning_of_month
        final_date = Date.today.end_of_month
        date_range = initial_date..final_date
      end
      date_range
    end
    
    def count_invoices(a,b)
      c = 0
      if a > 0
        c += 1
      end
      if b > 0
        c += 1
      end
      return c
    end

    def regime(inform)
      regime_type = Promoter.where(id: inform.promoter_id).first.regime
      case regime_type
      when "Contributivo"
        return "1"
      when "Subsidiado"
        return "2"
      when "Vinculado"
        return "3"
      when "Particular"
        return "4"
      when "Otro"
        return "5"
      when "Víctima con afiliación al Régimen Contributivo"
        return "6"
      when "Víctima con afiliación al Régimen subsidiado"
        return "7"
      when "Víctima no asegurado"
        return "8"
      end


    end

end
