class InclusionBlocksController < ApplicationController

	def inform_ok
		@block = Block.find(params[:block_id])	#Este es un block tipo A o A1, pilas!
		@sample = Sample.find(params[:sample_id])

		@inform = @block.inform 	#Defino el informe sobre el que estoy trabajando
		@blocks = @inform.blocks 	#Defino solo los bloques del informe que estoy trabajando
		@samples = @inform.samples.where(name: "Cassette") 	#Defino solo las samples que estoy trabajando

		@samples.each do |sample|	#Barro todas las muestras del informe
			@blocks.each do |block|	#Barro todos los bloques del informe
				if sample.sample_tag == block.block_tag	#Solo opero en las coincidencias, estoy en una collection, no en DB
					if sample.fragment != block.fragment
						log = "FECHA: " + Date.today.to_s
						log += " CAMBIOS: "
						log += " Fragmentos - ANTES: " + sample.fragment.to_s
						log += ", por: " + User.where(id: sample.user_id).first.try(:email).to_s
						log += " Fragmentos - DESPUES: " + block.fragment.to_s
						log += ", por: " + current_user.email + " \n"

						#Obcode 4 corresponde a Descripción Macro incompleta
						objection = block.objections.new(
							responsible_user_id: sample.user_id,
							user_id: current_user.id,
							description: log,
							obcode_id: 4,
							close_user_id: nil,
							closed: false
						) 
						#@objectionable se crea en una version (una clase heredada) personalizada del controlador de Objection para cada tipo de modelo DESDE DONDE se le llama
						objection.save
					else
						block.update(verified: true, user_id: current_user.id)
					end
					sample.update(included: true, user_id: current_user.id)
				end
			end
		end
		get_blocks
	end

	def inclusion
		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		  @a = []
		  b = []
		  i = 0
		  @allblocks = Block.where(created_at: date_range)
		  @allblocks.each_with_index do |block, n|
		  	b << block
		  	i = i + 1
		  	if i == 18
		  		@a << b
		  		b = []
		  		i = 0
		  	end
		  end
		  @a << b
		else
		  @blocks = Block.unscoped.all.select(:inform_id).group(:inform_id).distinct
		  @a = []
		  b = []
		  i = 0
		  @allblocks = Block.all
		  @allblocks.each_with_index do |block, n|
		  	b << block
		  	i = i + 1
		  	if i == 18
		  		@a << b
		  		b = []
		  		i = 0
		  	end
		  end
		  @a << b
		end

		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @samplesc = Sample.where(created_at: date_range, name: "Cassette")
		else
		  @samplesc = Sample.where(name: "Cassette")
		end
	end

	def block_fp1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i + 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		get_blocks
	end

	def block_fm1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i - 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		get_blocks
	end

	def get_blocks
		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		  @a = []
		  b = []
		  i = 0
		  @allblocks = Block.where(created_at: date_range)
		  @allblocks.each_with_index do |block, n|
		  	b << block
		  	i = i + 1
		  	if i == 18
		  		@a << b
		  		b = []
		  		i = 0
		  	end
		  end
		  @a << b
		else
		  @blocks = Block.unscoped.all.select(:inform_id).group(:inform_id).distinct
		  @a = []
		  b = []
		  i = 0
		  @allblocks = Block.all
		  @allblocks.each_with_index do |block, n|
		  	b << block
		  	i = i + 1
		  	if i == 18
		  		@a << b
		  		b = []
		  		i = 0
		  	end
		  end
		  @a << b
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
end
