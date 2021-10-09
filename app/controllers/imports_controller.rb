class ImportsController < ApplicationController
	before_action :authenticate_user!

	def oldrecord_import_index
		if params[:init_date] != nil
			initial_date = Date.parse(params[:init_date]).beginning_of_day
			final_date = Date.parse(params[:final_date]).end_of_day
			date_range = initial_date..final_date
			@oldrecords = Oldrecord.where(fecharec: date_range, patient_id: nil).paginate(page: params[:page], per_page: 10)
			
		else
			@oldrecords = Oldrecord.where(patient_id: nil).paginate(page: params[:page], per_page: 10)
			
		end
		# Oldrecord.unscoped.select(:cedula, :id, :nombre, :nombre2, :apellido, :apellido2, :identif).group(:id, :cedula).all
	end

	def oldcito_import_index
		if params[:init_date] != nil
			initial_date = Date.parse(params[:init_date]).beginning_of_day
			final_date = Date.parse(params[:final_date]).end_of_day
			date_range = initial_date..final_date
			@oldcitos = Oldcito.where(fecharec: date_range, patient_id: nil).paginate(page: params[:page], per_page: 10)
			
		else
			@oldcitos = Oldcito.where(patient_id: nil).paginate(page: params[:page], per_page: 10)
			
		end
	end

	def import_date_filter
		
	end

	def oldrecord_import_patient
		initial_date = Date.parse(params[:init_date]).beginning_of_day
		final_date = Date.parse(params[:final_date]).end_of_day
		date_range = initial_date..final_date
		@oldrecords = Oldrecord.where(fecharec: date_range)

		@oldrecords.find_each(batch_size: 10) do |oldrecord|

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
				@patient.id_number = "REVISAR-" + oldrecord.id.to_s	#Asigno un número que sería unico que es el id
				

				@patient.password = @patient.id_number
				@patient.password_confirmation = @patient.id_number
				
				@patient.save

				oldrecord.update(patient_id: @patient.id)
			else
				patients = Patient.where(id_number: oldrecord.cedula)
				if patients.count != 0 
					oldrecord.update(patient_id: patients.first.id)	#Si encuentra alguna cedula, debe ser única!
				else
					@patient.password = @patient.id_number
					@patient.password_confirmation = @patient.id_number
					
					@patient.save

					oldrecord.update(patient_id: @patient.id)
				end
			end
		end
		redirect_to imports_oldrecord_import_index_path
	end

	def oldcito_import_patient
		initial_date = Date.parse(params[:init_date]).beginning_of_day
		final_date = Date.parse(params[:final_date]).end_of_day
		date_range = initial_date..final_date
		@oldcitos = Oldcito.where(fecharec: date_range)

		@oldcitos.find_each(batch_size: 10) do |oldcito|

			@patient = Patient.new
			@patient.id_number = oldcito.cedula
			@patient.id_type = oldcito.identif
			if oldcito.identif == nil
				
				@patient.id_type = "**"
				
				if oldcito.uniedad == "1" && oldcito.edad != nil
					if oldcito.edad.to_i > 17
						@patient.id_type = "CC"
					else
						@patient.id_type = "TI"
					end
				end
			end
			
			
			@patient.name1 = oldcito.nombre
			@patient.name2 = oldcito.nombre2
			@patient.lastname1 = oldcito.apellido
			@patient.lastname2 = oldcito.apellido2
			@patient.sex = oldcito.sexo
			@patient.birth_date = oldcito.fechanac

			if oldcito.cedula == nil
				@patient.id_number = "REVISAR-" + oldcito.id.to_s	#Asigno un número que sería unico que es el id
				
				@patient.password = @patient.id_number
				@patient.password_confirmation = @patient.id_number
				
				@patient.save

				oldcito.update(patient_id: @patient.id)
			else
				patients = Patient.where(id_number: oldcito.cedula)
				if patients.count != 0 
					oldcito.update(patient_id: patients.first.id)	#Si encuentra alguna cedula, debe ser única!
				else
					@patient.password = @patient.id_number
					@patient.password_confirmation = @patient.id_number
					
					@patient.save

					oldcito.update(patient_id: @patient.id)
				end
			end
		end
		redirect_to imports_oldcito_import_index_path
	end

	private
		def fix_accent(descr)
			
			descr.gsub!("Ã\u009F","á")
			
			descr.gsub!("Ã\u009A","é")
			
			descr.gsub!("Ã\u009D","í")

			descr.gsub!("Â¾","ó")

			descr.gsub!("Ã\u008B","Ó")

			descr.gsub!("√ê", "Ñ")

			descr.gsub!("/", "Ñ")

			descr.gsub!("I–ì—í", "Ñ")
			
			return descr
		end

end
