class ListBlocksController < ApplicationController

	def get_samplesc_and_blocks
		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.where(created_at: date_range)
		else
		  @blocks = Block.all
		end

		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @samplesc = Sample.where(created_at: date_range, name: "Cassette")
		else
		  @samplesc = Sample.where(name: "Cassette")
		end
	end

	def anotate_block
		@block = Block.find(params[:block_id])
		# @samplesc = Sample.where(name: "Cassette")
		# @blocks = Block.all
		get_samplesc_and_blocks
		@objection = Objection.find(params[:objection_id])
		new_description = @objection.description.to_s + "FECHA: " + Date.today.to_s + " REVISIÓN: " + params[:new_description].to_s + ", por: " + current_user.email
		@objection.update(
			description: new_description,
			close_user_id: current_user.id,
			close_date: Date.today,
			closed: true
		)
		@block.update(verified: true, fragment: params[:fragment])
	end

	def review_block
		@block = Block.find(params[:block_id])
		# @samplesc = Sample.where(name: "Cassette")
		# @blocks = Block.all
		get_samplesc_and_blocks
		@objection = Objection.find(params[:objection_id])
		
	end

	def block_fp1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i + 1)

		# @samplesc = Sample.where(name: "Cassette")
		# @blocks = Block.all
		get_samplesc_and_blocks
	end

	def block_fok
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@sample.update(included: true)	#Marco la muestra como incluida en parafina, por lo que oficilamente el bloque queda confirmado con esos fragmentos

		# @samplesc = Sample.where(name: "Cassette")
		# @blocks = Block.all
		get_samplesc_and_blocks

		if @sample.fragment != @block.fragment
			log = "FECHA: " + Date.today.to_s
			log += " CAMBIOS: "
			log += " Fragmentos - ANTES: " + @sample.fragment.to_s
			log += ", por: " + User.where(id: @sample.user_id).first.try(:email).to_s
			log += " Fragmentos - DESPUES: " + @block.fragment.to_s
			log += ", por: " + current_user.email + " \n"

			#Obcode 4 corresponde a Descripción Macro incompleta
			objection = @block.objections.new(
				responsible_user_id: @sample.user_id,
				user_id: current_user.id,
				description: log,
				obcode_id: 4,
				close_user_id: nil,
				closed: false
			) 
			#@objectionable se crea en una version (una clase heredada) personalizada del controlador de Objection para cada tipo de modelo DESDE DONDE se le llama
			objection.save
		else
			@block.update(verified: true, user_id: current_user.id)
		end
		@sample.update(included: true, user_id: current_user.id)
	end

	def block_fm1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i - 1)

		# @samplesc = Sample.where(name: "Cassette")
		# @blocks = Block.all
		get_samplesc_and_blocks
	end
end
