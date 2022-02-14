namespace :oldrecords do
  task :import_count => :environment do
    date_range = Date.parse("01-01-2021")..Date.parse("31-12-2021")
    oldrecords = Oldrecord.where(fecharec: date_range, patient_id: nil)
    total = oldrecords.count
    puts "El total a importar es: #{total}"
  end

  task :import => :environment do
    date_range = Date.parse("01-01-2021")..Date.parse("31-12-2021")
    oldrecords = Oldrecord.where(fecharec: date_range, patient_id: nil)
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
        puts "Paciente #{n} de #{total}: #{patient.id_number} #{100 * n / total}%"
      else
        patients = Patient.where(id_number: oldrecord.cedula)
        if patients.count != 0 
          oldrecord.update(patient_id: patients.first.id) #Si encuentra alguna cedula, debe ser única!
        else
          patient.password = patient.id_number
          patient.password_confirmation = patient.id_number
          
          patient.save

          oldrecord.update(patient_id: patient.id)
          puts "Paciente #{n} de #{total}: #{patient.id_number} #{100 * n / total}%"
        end
      end
    end
  end
end

namespace :oldcitos do
  task :import_count => :environment do
    date_range = Date.parse("01-01-2021")..Date.parse("31-12-2021")
    oldcitos = Oldcito.where(fecharec: date_range, patient_id: nil)
    total = oldcitos.count
    puts "El total a importar es: #{total}"
  end

  task :import => :environment do
    date_range = Date.parse("01-01-2021")..Date.parse("31-12-2021")
    oldcitos = Oldcito.where(fecharec: date_range, patient_id: nil)
    total = oldcitos.count

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
        puts "Paciente #{n} de #{total}: #{patient.id_number} #{100 * n / total}%"
      else
        patients = Patient.where(id_number: oldcito.cedula)
        if patients.count != 0 
          oldcito.update(patient_id: patients.first.id) #Si encuentra alguna cedula, debe ser única!
        else
          patient.password = patient.id_number
          patient.password_confirmation = patient.id_number
          
          begin
            patient.save!
          rescue StandardError => e
            puts "Resuced: #{e.message}"
          end

          oldcito.update(patient_id: patient.id)
          puts "Paciente #{n} de #{total}: #{patient.id_number} #{100 * n / total}%"
        end
      end
    end
  end
end
