class InclusionBlocksController < ApplicationController

	def inclusion
		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.where(created_at: date_range).joins("INNER JOIN samples ON blocks.block_tag = samples.sample_tag")
		  @samplesc = Sample.where(created_at: date_range, name: "Cassette").joins("INNER JOIN blocks ON blocks.block_tag = samples.sample_tag")
		  build_inclusion
		else
		  @blocks = Block.joins("INNER JOIN samples ON blocks.block_tag = samples.sample_tag")
		  @samplesc = Sample.where(name: "Cassette").joins("INNER JOIN blocks ON blocks.block_tag = samples.sample_tag")
		  build_inclusion
		end
	end

	def build_inclusion
		@inclusion = []
		@blocks.each_with_index do |block, n|
			@inclusion << [ block, @samplesc[n], block.block_tag, @samplesc[n].fragment, block.fragment ]
		end
	end

	def inform_ok
		@block = Block.find(params[:block_id])	#Este es un block tipo A o A1, pilas!
		@sample = Sample.find(params[:sample_id])

		@inform = @block.inform 	#Defino el informe sobre el que estoy trabajando
		@blocks = @inform.blocks 	#Defino solo los bloques del informe que estoy trabajando
		
		@samples = @inform.samples.where(name: "Cassette")

		@blocks.each do |block|	#Barro todos los bloques del informe
			
			@samples.each do |s|
				if s.sample_tag == block.block_tag
					@sample = s
					break
				end
			end

			if @sample.fragment != block.fragment
				log = "FECHA: " + Date.today.to_s
				log += " CAMBIOS: "
				log += " Fragmentos - ANTES: " + @sample.fragment.to_s
				log += ", por: " + User.where(id: @sample.user_id).first.try(:email).to_s
				log += " Fragmentos - DESPUES: " + block.fragment.to_s
				log += ", por: " + current_user.email + " \n"

				#Obcode 4 corresponde a Descripción Macro incompleta
				objection = block.objections.new(
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
				block.update(verified: true, user_id: current_user.id)
			end
			# sample.update(included: true, user_id: current_user.id)
			# end
		end
		@inform.samples.where(name: "Cassette").update_all(included: true, user_id: current_user.id) 	#Defino solo las samples que estoy trabajando
		# end
		get_blocks
	end

	def block_fp1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: @block.fragment + 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		get_blocks
	end

	def block_fm1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: @block.fragment - 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		get_blocks
	end

	def get_blocks
		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.where(created_at: date_range).joins("INNER JOIN samples ON blocks.block_tag = samples.sample_tag").select("blocks.block_tag, blocks.fragment")
		  @samplesc = Sample.where(created_at: date_range, name: "Cassette").joins("INNER JOIN blocks ON blocks.block_tag = samples.sample_tag")
		  build_inclusion
		else
		  @blocks = Block.joins("INNER JOIN samples ON blocks.block_tag = samples.sample_tag")
		  @samplesc = Sample.where(name: "Cassette").joins("INNER JOIN blocks ON blocks.block_tag = samples.sample_tag")
		  build_inclusion
		end
	end
end
