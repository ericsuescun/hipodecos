task :ghost_informs => :environment do
  p = Patient.new
  p.name1 = 'Nombre1'
  p.name2 = 'Nombre2'
  p.lastname1 = 'Apellido1'
  p.lastname2 = 'Apellido2'
  p.id_type = 'CC'
  p.id_number = '00000000'
  p.sex = 'X'
  p.save

  n = 20
  n.times do |m|
    inform = p.informs.build
    inform.entity_id = Entity.first.id
    inform.regime = Promoter.first.try(:regime)
    inform.inf_status = 'invalid'
    inform.inf_type = 'clin'

    consecutive = Inform.where(inf_type: 'clin', created_at: date_range).count + 1
    inform.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    inform.save
    puts "Informe #{m} de #{n}"
  end

  n = 20
  n.times do |m|
    inform = p.informs.build
    inform.entity_id = Entity.first.id
    inform.regime = Promoter.first.try(:regime)
    inform.inf_status = 'invalid'
    inform.inf_type = 'hosp'

    consecutive = Inform.where(inf_type: 'hosp', created_at: date_range).count + 1
    inform.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    inform.save
    puts "Informe #{m} de #{n}"
  end

  n = 20
  n.times do |m|
    inform = p.informs.build
    inform.entity_id = Entity.first.id
    inform.regime = Promoter.first.try(:regime)
    inform.inf_status = 'invalid'
    inform.inf_type = 'cito'

    consecutive = Inform.where(inf_type: 'cito', created_at: date_range).count + 1
    inform.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    inform.save
    puts "Informe #{m} de #{n}"
  end

end
