class RipsAdAfCtUsJob < ApplicationJob
  queue_as :default

  def perform(params)
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
    
    if @total_detail_clin.size > 0
      file += @total_detail_clin.first[2].invoice + "," + "050011134601,02," + @total_users_clin.count.to_s + ",," + @total_accumulated_clin.to_i.to_s + "\r\n"
    end
    if @total_detail_cito.size > 0
      file += @total_detail_cito.first[2].invoice + "," + "050011134601,02," + @total_users_cito.count.to_s + ",," + @total_accumulated_cito.to_i.to_s + "\r\n"
    end

    @filename = "AD" + 1.month.ago.strftime("%m%Y") + ".TXT"
    
    @file = File.new(@filename, 'w+')
    @file.write(file)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "AD")

    file = ""
    
    if @total_detail_clin.size > 0
      file += "050011134601,PATOLOGIA SUESCUN SAS,NI,900363326-8," + @total_detail_clin.first[2].invoice + "," + Date.today.strftime("%d/%m/%Y") + "," + Date.parse(params[:init_date]).strftime("%d/%m/%Y") + "," + Date.parse(params[:final_date]).strftime("%d/%m/%Y") + ",000000," + Entity.where(id: params[:id]).first.name.upcase + ",,CONTRIBUTIVO,,,,," + @total_accumulated_clin.to_i.to_s + "\r\n"
    end
    if @total_detail_cito.size > 0
      file += "050011134601,PATOLOGIA SUESCUN SAS,NI,900363326-8," + @total_detail_cito.first[2].invoice + "," + Date.today.strftime("%d/%m/%Y") + "," + Date.parse(params[:init_date]).strftime("%d/%m/%Y") + "," + Date.parse(params[:final_date]).strftime("%d/%m/%Y") + ",000000," + Entity.where(id: params[:id]).first.name.upcase + ",,CONTRIBUTIVO,,,,," + @total_accumulated_cito.to_i.to_s + "\r\n"
    end
    
    @filename = "AF" + 1.month.ago.strftime("%m%Y") + ".TXT"
    
    @file = File.new(@filename, 'w+')
    @file.write(file)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "AF")

    file = ""
    
    file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "US" + 1.month.ago.strftime("%m%Y") + "," + (@total_users_clin.count + @total_users_cito.count).to_s  + "\r\n"
    file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "AP" + 1.month.ago.strftime("%m%Y") + "," + (@total_detail.count).to_s + "\r\n"
    file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "AF" + 1.month.ago.strftime("%m%Y") + "," + count_invoices(@total_users_clin.count, @total_users_cito.count).to_s + "\r\n"
    file += "050011134601," + Date.today.strftime("%d/%m/%Y") + "," + "AD" + 1.month.ago.strftime("%m%Y") + "," + count_invoices(@total_users_clin.count, @total_users_cito.count).to_s + "\r\n"

    @filename = "CT" + 1.month.ago.strftime("%m%Y") + ".TXT"

    @file = File.new(@filename, 'w+')
    @file.write(file)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "CT")

    @total_users = []
    @price = 0
    @entity.branches.each do |branch|
      Inform.where(inf_status: "published", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "").or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range, entity_id: @entity.id, branch_id: branch.id).where.not(invoice: "")).each do |inform|
        @total_users << [ inform.patient.id_type, inform.patient.id_number, "000000", regime(inform), inform.patient.lastname1.to_s.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase.strip, inform.patient.lastname2.to_s.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase.strip, inform.patient.name1.to_s.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase.strip, inform.patient.name2.to_s.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase.strip, inform.p_age, inform.p_age_type == "A" ? "1" : inform.p_age_type == "M" ? "2" : "3", inform.patient.sex, inform.p_municipality[0..1], inform.p_municipality[2..4], inform.zone_type ]
      end
    end
    @total_users = @total_users.uniq  #Purgo los repetidos

    users = ""

    @total_users.each do |user|
      users += user.join(",") + "\r\n"
    end

    @filename = "US" + 1.month.ago.strftime("%m%Y") + ".TXT"

    @file = File.new(@filename, 'w+')
    @file.write(users)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "US")
  end

  private

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
end
