class AffDetEncJob < ApplicationJob
  queue_as :default

  def perform(params)
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

    @filename = "detalle_#{params[:inf_type]}_" + @invoice + ".TXT"

    @file = File.new(@filename, 'w+')
    @file.write(file)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "Detalles")

    file = ""

    file += "ET,1000,1," + invoice_date.strftime("%Y-%m-%d") + ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n"
    file += "EB,1,8001,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n"
    file += "RG,1,0000," + invoice_date.strftime("%Y-%m-%d") + "," + @invoice + ",042,VTA03,11001," + @entity.tax_id + ",04, , ,Facturacion periodo " + Date.parse(params[:init_date]).strftime("%d/%m/%Y") + " a " + Date.parse(params[:final_date]).strftime("%d/%m/%Y") + ",,015,15,10,2,1,60,0,0," + @total_accumulated.to_i.to_s + ", , , , ,00,0, , ,N,P,0, ,0, ," + @total_accumulated.to_i.to_s + ", , , , , , , , , , ,S,S,10, , , , , \r\n"

    file += "FB,1,8001,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," + "\r\n"
    file += "FT,1000,1,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"

    @filename = "enc_#{params[:inf_type]}_" + @invoice + ".TXT"

    @file = File.new(@filename, 'w+')
    @file.write(file)
    @file.close
    UtilityFile.create(name: @filename, filepath: @file.path, description: "Encabezados")
  end
end