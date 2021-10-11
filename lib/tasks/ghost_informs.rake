task :ghost_informs => :environment do
  date_range = Date.parse("01-01-2021")..Date.parse("31-12-2021")

  p = Patient.new
  p.name1 = 'Nombre1'
  p.name2 = 'Nombre2'
  p.lastname1 = 'Apellido1'
  p.lastname2 = 'Apellido2'
  p.id_type = 'CC'
  p.id_number = '11222333'
  p.sex = 'X'
  p.save

  n = 432
  n.times do |m|
    inform = p.informs.build
    inform.entity_id = Entity.first.id
    inform.branch_id = Branch.first.id
    inform.regime = Promoter.first.try(:regime)
    inform.inf_status = 'invalid'
    inform.inf_type = 'clin'
    inform.zone_type = 'U'
    inform.receive_date = Date.today - 6.months

    adjust = 0
    adjust = Oldrecord.where(clave: 'C', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
    consecutive = Inform.where(inf_type: 'clin', created_at: date_range).count + 1 + adjust
    inform.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    inform.save
    puts "Informe #{m} de #{n}"
  end

  n = 98
  n.times do |m|
    inform = p.informs.build
    inform.entity_id = Entity.first.id
    inform.branch_id = Branch.first.id
    inform.regime = Promoter.first.try(:regime)
    inform.inf_status = 'invalid'
    inform.inf_type = 'hosp'
    inform.zone_type = 'U'
    inform.receive_date = Date.today - 6.months

    adjust = 0
    adjust = Oldrecord.where(clave: 'H', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
    consecutive = Inform.where(inf_type: 'hosp', created_at: date_range).count + 1 + adjust
    inform.tag_code = "H" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    inform.save
    puts "Informe #{m} de #{n}"
  end

  n = 674
  n.times do |m|
    inform = p.informs.build
    inform.entity_id = Entity.first.id
    inform.branch_id = Branch.first.id
    inform.regime = Promoter.first.try(:regime)
    inform.inf_status = 'invalid'
    inform.inf_type = 'cito'
    inform.zone_type = 'U'
    inform.receive_date = Date.today - 6.months

    adjust = 0
    adjust = Oldcito.where(clave: 'K', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
    consecutive = Inform.where(inf_type: 'cito', created_at: date_range).count + 1 + adjust
    inform.tag_code = "K" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    inform.save
    puts "Informe #{m} de #{n}"
  end

end
