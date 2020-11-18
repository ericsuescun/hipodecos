class ListBlocksController < ApplicationController
	before_action :authenticate_user!

	def add_block_slide
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		# @blocks = @inform.blocks
		# @samplesc = @inform.samples.where(name: "Cassette")
		get_samplesc_and_blocks
		# @recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first
		@inform = @block.inform
		@inform.slides.create(slide_tag: params[:block_tag], user_id: current_user.id)	#Se crea un slide con el mismo tag de la sample
		@block.update(slide_tag: params[:block_tag])	#Se guarda el tag creado en el block para que queden asociados
	end

	def add_block_series
		# @blocks = @inform.blocks
		# @samplesc = @inform.samples.where(name: "Cassette")
		get_samplesc_and_blocks
		@block = Block.find(params[:block_id])
		@inform = @block.inform
		@inform.slides.create(slide_tag: @block.block_tag + "*", user_id: current_user.id)
	end

	def associate_block_slide
		# @automatics = Automatic.all 	#Para poder renderizar recipients entero...
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		
		# @samplesc = @inform.samples.where(name: "Cassette")
		# @recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first

		@block.update(slide_tag: params[:destination_slide], user_id: current_user.id)	#Se taggea la sample actual con el slide seleccionado

		@slide = Slide.where(slide_tag: params[:destination_slide]).first	#Traigo el slide actual

		new_tag = @slide.slide_tag + "-" + get_nomen(@block.block_tag)	#Calculo el nuevo tag
		@slide.update(slide_tag: new_tag, user_id: current_user.id)	#Actualizo la slide con ese nuevo tag

		@inform = @sample.inform
		@blocks = @inform.blocks.where(slide_tag: params[:destination_slide]) #Busco todas las samples de ese informe con ese slide asociado (por el tag)

		@blocks.each do |block|
			block.update(slide_tag: new_tag, user_id: current_user.id)	#Actualizo todas las samples asociadas con el nuevo tag
		end
		# @blocks = @inform.blocks	#Tengo que enviar todos los blocks para renderizado!
		get_samplesc_and_blocks
	end

	def get_samplesc_and_blocks
		# if params[:yi] != ""
		#   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		#   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		#   date_range = initial_date..final_date
		#   @blocks = Block.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		# else
		#   @blocks = Block.unscoped.all.select(:inform_id).group(:inform_id).distinct
		# end

		# if params[:yi] != ""
		#   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		#   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		#   date_range = initial_date..final_date
		#   @samplesc = Sample.where(created_at: date_range, name: "Cassette")
		# else
		#   @samplesc = Sample.where(name: "Cassette")
		# end

		if params[:init_date]
		  initial_date = Date.parse(params[:init_date]).beginning_of_day
		  final_date = Date.parse(params[:final_date]).end_of_day
		  date_range = initial_date..final_date
		  
		else
		  initial_date = 1.day.ago.beginning_of_day
		  final_date = Time.now.end_of_day
		  date_range = initial_date..final_date
		end
		@blocks = Block.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		# @samplesc = Sample.where(created_at: date_range, name: "Cassette")
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
		@block.update(verified: true, fragment: params[:fragment], user_id: current_user.id)
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
		@block.update(fragment: params[:fragment].to_i + 1, user_id: current_user.id)

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
		@block.update(fragment: params[:fragment].to_i - 1, user_id: current_user.id)

		# @samplesc = Sample.where(name: "Cassette")
		# @blocks = Block.all
		get_samplesc_and_blocks
	end

	def get_nomen(str)
		return str.split('-',2)[1].split('-',2)[1]
	end
end
