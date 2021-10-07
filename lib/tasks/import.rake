namespace :oldrecords do
  task :import_count => :environment do
    date_range = Date.parse("01-01-2020")..Date.parse("31-05-2020")
    oldrecords = Oldrecord.where(fecharec: date_range)
    total = oldrecords.count
    puts "El total a importar es: #{total}"
  end

  task :import => :environment do
    date_range = Date.parse("01-01-2020")..Date.parse("31-05-2020")
    oldrecords = Oldrecord.where(fecharec: date_range)
    total = oldrecords.count

    oldrecords.each_with_index do |oldrecord, n|

      patient = Patient.new
      patient.id_number = oldrecord.cedula
      patient.id_type = oldrecord.identif
      if oldrecord.identif == nil
        
        patient.id_type = "**"
        
        if oldrecord.uniedad == "1" && oldrecord.edad != nil
          if oldrecord.edad.to_i > 17
            patient.id_type = "CC"
          else
            patient.id_type = "TI"
          end
        end
      end
      
      
      patient.name1 = oldrecord.nombre
      patient.name2 = oldrecord.nombre2
      patient.lastname1 = oldrecord.apellido
      patient.lastname2 = oldrecord.apellido2
      patient.sex = oldrecord.sexo

      if oldrecord.cedula == nil
        patient.id_number = "REVISAR-" + oldrecord.id.to_s #Asigno un número que sería unico que es el id
        

        patient.password = patient.id_number
        patient.password_confirmation = patient.id_number

        patient.save

        oldrecord.update(patient_id: patient.id)
        puts "Paciente #{n} de #{total}: #{patient.id_number}"
      else
        patients = Patient.where(id_number: oldrecord.cedula)
        if patients.count != 0 
          oldrecord.update(patient_id: patients.first.id) #Si encuentra alguna cedula, debe ser única!
        else
          patient.password = patient.id_number
          patient.password_confirmation = patient.id_number
          
          patient.save

          oldrecord.update(patient_id: patient.id)
          puts "Paciente #{n} de #{total}: #{patient.id_number}"
        end
      end
    end
  end

  task :import_count => :environment do
    date_range = Date.parse("01-01-2020")..Date.parse("31-05-2020")
    oldrecords = Oldcito.where(fecharec: date_range)
    total = oldrecords.count
    puts "El total a importar es: #{total}"
  end

  task :import => :environment do
    date_range = initial_date..final_date
    oldcitos = Oldcito.where(fecharec: date_range)

    oldcitos.each_with_index do |oldcito, n|

      patient = Patient.new
      patient.id_number = oldcito.cedula
      patient.id_type = oldcito.identif
      if oldcito.identif == nil
        
        patient.id_type = "**"
        
        if oldcito.uniedad == "1" && oldcito.edad != nil
          if oldcito.edad.to_i > 17
            patient.id_type = "CC"
          else
            patient.id_type = "TI"
          end
        end
      end
      
      
      patient.name1 = oldcito.nombre
      patient.name2 = oldcito.nombre2
      patient.lastname1 = oldcito.apellido
      patient.lastname2 = oldcito.apellido2
      patient.sex = oldcito.sexo
      patient.birth_date = oldcito.fechanac

      if oldcito.cedula == nil
        patient.id_number = "REVISAR-" + oldcito.id.to_s #Asigno un número que sería unico que es el id
        
        patient.password = patient.id_number
        patient.password_confirmation = patient.id_number
        
        patient.save

        oldcito.update(patient_id: patient.id)
        puts "Paciente #{n} de #{total}: #{patient.id_number}"
      else
        patients = Patient.where(id_number: oldcito.cedula)
        if patients.count != 0 
          oldcito.update(patient_id: patients.first.id) #Si encuentra alguna cedula, debe ser única!
        else
          patient.password = patient.id_number
          patient.password_confirmation = patient.id_number
          
          patient.save

          oldcito.update(patient_id: patient.id)
          puts "Paciente #{n} de #{total}: #{patient.id_number}"
        end
      end
    end
  end
end
