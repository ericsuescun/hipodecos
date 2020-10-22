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
	end

	def import_date_filter
		
	end

	def import_patient
		initial_date = Date.parse(params[:init_date]).beginning_of_day
		final_date = Date.parse(params[:final_date]).end_of_day
		date_range = initial_date..final_date
		@oldrecords = Oldrecord.where(fecharec: date_range)

		@oldrecords.each do |oldrecord|

			id_number = oldrecord.cedula
			id_type = oldrecord.identif
			name1 = oldrecord.nombre
			name2 = oldrecord.nombre2
			lastname1 = oldrecord.apellido
			lastname2 = oldrecord.apellido2
			sex = oldrecord.sexo

			if oldrecord.cedula == nil
				if oldrecord.historia == nil
					id_number = "REV-" + oldrecord.id.to_s	#Asigno un número que sería unico que es el id
					id_type = "**"	#Marco el registro para el futuro
					patient = Patient.new(
						id_number: id_number,
						id_type: id_type,
						name1: name1,
						name2: name2,
						lastname1: lastname1,
						lastname2: lastname2,
						sex: sex,
						password: id_number,
						password_confirmation: id_number
						)
					patient.save

					oldrecord.update(patient_id: patient.id)
				else
					id_number = oldrecord.historia
					id_type == "**"
					patients = Patient.where(id_number: oldrecord.historia)
					if patients.count != 0 
						oldrecord.update(patient_id: patients.first.id)	#Si encuentra alguna cedula, debe ser única!
					else
						patient = Patient.new(
							id_number: id_number,
							id_type: id_type,
							name1: name1,
							name2: name2,
							lastname1: lastname1,
							lastname2: lastname2,
							sex: sex,
							password: id_number,
							password_confirmation: id_number
							)
						patient.save

						oldrecord.update(patient_id: patient.id)
					end
				end
				
			else
				patients = Patient.where(id_number: oldrecord.cedula)
				if patients.count != 0 
					oldrecord.update(patient_id: patients.first.id)	#Si encuentra alguna cedula, debe ser única!
				else
					patient = Patient.new(
						id_number: id_number,
						id_type: id_type,
						name1: name1,
						name2: name2,
						lastname1: lastname1,
						lastname2: lastname2,
						sex: sex,
						password: id_number,
						password_confirmation: id_number
						)
					patient.save

					oldrecord.update(patient_id: patient.id)
				end
			end
		end
		render :import_index
	end

end
