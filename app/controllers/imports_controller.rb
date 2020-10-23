class ImportsController < ApplicationController

	def import_index
		if params[:init_date] != nil
			initial_date = Date.parse(params[:init_date]).beginning_of_day
			final_date = Date.parse(params[:final_date]).end_of_day
			date_range = initial_date..final_date
			@oldrecords = Oldrecord.where(fecharec: date_range, patient_id: nil)
			@oldrecordsl = Oldrecord.where(fecharec: date_range, patient_id: nil).limit(20)
		else
			@oldrecords = Oldrecord.where(patient_id: nil)
			@oldrecordsl = Oldrecord.where(patient_id: nil).limit(20)
		end
		@patient = Patient.first
	end

	def import_date_filter
		
	end

	def import_patient
		initial_date = Date.parse(params[:init_date]).beginning_of_day
		final_date = Date.parse(params[:final_date]).end_of_day
		date_range = initial_date..final_date
		@oldrecords = Oldrecord.where(fecharec: date_range)

		@oldrecords.each do |oldrecord|

			@patient = Patient.new
			@patient.id_number = oldrecord.cedula
			@patient.id_type = oldrecord.identif
			if oldrecord.identif == nil
				
				@patient.id_type = "**"
				
				if oldrecord.uniedad == "1" && oldrecord.edad != nil
					if oldrecord.edad.to_i > 17
						@patient.id_type = "CC"
					else
						@patient.id_type = "TI"
					end
				end
			end
			
			
			@patient.name1 = oldrecord.nombre
			@patient.name2 = oldrecord.nombre2
			@patient.lastname1 = oldrecord.apellido
			@patient.lastname2 = oldrecord.apellido2
			@patient.sex = oldrecord.sexo

			if oldrecord.cedula == nil
				if oldrecord.historia == nil
					@patient.id_number = "REVISAR-" + oldrecord.id.to_s	#Asigno un número que sería unico que es el id
					# @patient.id_type = "**"	#Marco el registro para el futuro
				else
					@patient.id_number = "REVISAR-" + oldrecord.id.to_s	#Asigno un número que sería unico que es el id
					# @patient.id_type == "**"
				end
				
				@patient.save

				oldrecord.update(patient_id: @patient.id)
			else
				patients = Patient.where(id_number: oldrecord.cedula)
				if patients.count != 0 
					oldrecord.update(patient_id: patients.first.id)	#Si encuentra alguna cedula, debe ser única!
				else
					
					@patient.save

					oldrecord.update(patient_id: @patient.id)
				end
			end
		end
		redirect_to imports_import_index_path
	end

end
