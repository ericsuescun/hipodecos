class RipsApJob < ApplicationJob
  queue_as :default

  def perform(params)
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
          study.factor.times do
            @price = study.price #Aca no acumulo el valor!
          @total_detail += inform.invoice + "," + "050011134601" + "," + inform.patient.id_type + "," + inform.patient.id_number + "," + inform.delivery_date.strftime("%d/%m/%Y") + "," + inform.prmtr_auth_code + "," + Codeval.where(id: study.codeval_id).first.code + "," + inform.status + "," + "1," + "," + "," + "," + "," + "," + @price.to_i.to_s + "\r\n"
          end
        end
      end
    end
    @filename = "AP" + 1.month.ago.strftime("%m%Y") + ".TXT"

    @file = File.new(@filename, 'w+')
    @file.write(@total_detail)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "AP")
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
