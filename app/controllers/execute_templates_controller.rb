class ExecuteTemplatesController < ApplicationController
	before_action :authenticate_user!

	def anotate_block
		@block = Block.find(params[:block_id])
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		@blocks = @inform.blocks
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
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		@blocks = @inform.blocks
		@objection = Objection.find(params[:objection_id])
		
	end

	def block_fp1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i + 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		@blocks = @inform.blocks
	end

	def block_fok
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@sample.update(included: true)	#Marco la muestra como incluida en parafina, por lo que oficilamente el bloque queda confirmado con esos fragmentos
		@inform = @sample.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		@blocks = @inform.blocks

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
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		@blocks = @inform.blocks
	end

	def create_blocks
		@inform = Inform.find(params[:inform_id])
		@blocks = @inform.blocks
		@samplesc = @inform.samples.where(name: "Cassette")
		@samplesc.each do |sample|
			if sample.blocked != true
				@inform.blocks.create!(
					user_id: current_user.id,
					block_tag: sample.sample_tag,
					description: sample.description,
					organ_code: sample.organ_code,
					fragment: sample.fragment,
					slide_tag: nil,
					verified: false
				)
				sample.update(blocked: true)
			end
		end
	end

	def add_slide
		@inform = Inform.find(params[:inform_id])
		@sample = Sample.find(params[:sample_id])
		@recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first
		@inform.slides.create(slide_tag: params[:sample_tag], user_id: current_user.id)	#Se crea un slide con el mismo tag de la sample
		@sample.update(slide_tag: params[:sample_tag])	#Se guarda el tag creado en la sample para que queden asociados
	end

	def add_block_slide
		@inform = Inform.find(params[:inform_id])
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@blocks = @inform.blocks
		@samplesc = @inform.samples.where(name: "Cassette")
		@recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first
		@inform.slides.create(slide_tag: params[:block_tag], user_id: current_user.id)	#Se crea un slide con el mismo tag de la sample
		@block.update(slide_tag: params[:block_tag])	#Se guarda el tag creado en el block para que queden asociados
	end

	def add_series
		@inform = Inform.find(params[:inform_id])
		@inform.slides.create(slide_tag: params[:sample_tag] + "*", user_id: current_user.id)
	end

	def add_block_series
		@inform = Inform.find(params[:inform_id])
		@blocks = @inform.blocks
		@samplesc = @inform.samples.where(name: "Cassette")
		@inform.slides.create(slide_tag: params[:block_tag] + "*", user_id: current_user.id)
	end

	def associate_slide
		@automatics = Automatic.all 	#Para poder renderizar recipients entero...
		@sample = Sample.find(params[:sample_id])
		@inform = @sample.inform
		@recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first

		@sample.update(slide_tag: params[:destination_slide])	#Se taggea la sample actual con el slide seleccionado

		@slide = Slide.where(inform_id: params[:inform_id], slide_tag: params[:destination_slide]).first	#Traigo el slide actual

		new_tag = @slide.slide_tag + "-" + get_nomen(@sample.sample_tag)	#Calculo el nuevo tag
		@slide.update(slide_tag: new_tag, user_id: current_user.id)	#Actualizo la slide con ese nuevo tag

		@samples = Inform.find(params[:inform_id]).samples.where(slide_tag: params[:destination_slide]) #Busco todas las samples de ese informe con ese slide asociado (por el tag)

		@samples.each do |sample|
			sample.update(slide_tag: new_tag)	#Actualizo todas las samples asociadas con el nuevo tag
		end
	end

	def associate_block_slide
		@automatics = Automatic.all 	#Para poder renderizar recipients entero...
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@inform = @sample.inform
		
		@samplesc = @inform.samples.where(name: "Cassette")
		@recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first

		@block.update(slide_tag: params[:destination_slide], user_id: current_user.id)	#Se taggea la sample actual con el slide seleccionado

		@slide = Slide.where(inform_id: params[:inform_id], slide_tag: params[:destination_slide]).first	#Traigo el slide actual

		new_tag = @slide.slide_tag + "-" + get_nomen(@block.block_tag)	#Calculo el nuevo tag
		@slide.update(slide_tag: new_tag, user_id: current_user.id)	#Actualizo la slide con ese nuevo tag

		@blocks = Inform.find(params[:inform_id]).blocks.where(slide_tag: params[:destination_slide]) #Busco todas las samples de ese informe con ese slide asociado (por el tag)

		@blocks.each do |block|
			block.update(slide_tag: new_tag, user_id: current_user.id)	#Actualizo todas las samples asociadas con el nuevo tag
		end
		@blocks = @inform.blocks	#Tengo que enviar todos los blocks para renderizado!
	end
	
	def create
		@inform = Inform.find(params[:inform_id])
		if params[:automatic] == nil
			@automatic = Automatic.where(title: params[:title]).first
		else
			@automatic = Automatic.find(params[:automatic])
		end
		@automatic.scripts.each do |script|
			case script.script_type
			when "rec"
				@recipient = @inform.recipients.build
				@recipient.tag = generate_rec_tag
				@recipient.user_id = current_user.id
				@recipient.description = script.description
				@recipient.save

				if params[:samples] != nil
					params[:samples].to_i.times do |n|
						@sample = @inform.samples.build
						@sample.user_id = current_user.id
						@sample.name = "Cassette"
						@sample.included = false
						@sample.recipient_tag = @recipient.tag
						@sample.sample_tag = generate_letter_tag(@inform)
						if params[:organ] != "" && @automatic.organ == ""
							@sample.organ_code = params[:organ]
						else
							@sample.organ_code = @automatic.organ == "" ? nil : @automatic.organ
						end
						@sample.description = script.description
						@sample.fragment = script.param1
						@sample.save

						@last_sample = @sample
					end
				end

			when "blo"
				@sample = @inform.samples.build
				@sample.user_id = current_user.id
				@sample.name = "Cassette"
				@sample.included = false
				@sample.recipient_tag = @recipient.tag
				@sample.sample_tag = generate_letter_tag(@inform)
				@sample.organ_code = script.organ == "" ? nil : script.organ
				@sample.description = script.description
				@sample.fragment = script.param1
				@sample.save

				@last_sample = @sample

			when "cor"
				@sample = @inform.samples.build
				@sample.user_id = current_user.id
				@sample.name = "Cassette"
				@sample.included = false
				@sample.recipient_tag = @recipient.tag
				@sample.sample_tag = generate_number_tag(@last_sample)
				if @sample.sample_tag[-1] == '2'
				  fix_sample = @last_sample
				  if fix_sample
				    fix_sample.update(sample_tag: @sample.sample_tag[0..-2] + '1')
				  end
				end
				@sample.organ_code = script.organ == "" ? nil : script.organ
				@sample.description = script.description
				@sample.fragment = script.param1
				@sample.save

				@last_sample = @sample

			when "ext"
				@sample = @inform.samples.build
				@sample.user_id = current_user.id
				@sample.name = "Extendido"
				@sample.included = false
				@sample.recipient_tag = @recipient.tag
				@sample.sample_tag = generate_letter_tag(@inform)
				@sample.organ_code = script.organ == "" ? nil : script.organ
				@sample.description = script.description
				@sample.fragment = script.param1
				@sample.save

				@last_sample = @sample	
			end
		end

		redirect_to @inform
	end

	def micro
		@inform = Inform.find(params[:inform_id])
		@script = Script.find(params[:script_id])
		@micro = @inform.micros.build
		@micro.user_id = current_user.id
		@micro.description = @script.description
		
		@micro.save

		@diagnostic = @inform.diagnostics.build
		@diagnostic.user_id = current_user.id
		@diagnostic.description = @script.diagnostic
		@diagnostic.diagcode_id = Diagcode.where(pss_code: @script.pss_code).first.id
		@diagnostic.pss_code = @script.pss_code
		@diagnostic.who_code = @script.who_code

		@diagnostic.save

		@automatics = []
		# @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
		Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
		  Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
		    @automatics << auto
		  end
		end

		# También hay que enviar diagcodes por lo que micro.js también despliega los diagnostics
		@diagcodes = []
		# @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
		Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
		  o_code = Organ.where(organ: sample.organ_code).first.organ_code.to_i
		  Diagcode.where(organ_code: o_code).each do |diagcode|
		  	if diagcode.pss_code != nil
		  	  diagcode.description = diagcode.pss_code.to_s + " - " + diagcode.description.to_s 
		  	else
		  	  diagcode.description = " ---- " + diagcode.description.to_s + " ---- "
		  	end
		  	@diagcodes << diagcode
		  end
		end

		@edit_status = false
	end

		def micro_new
		@inform = Inform.find(params[:inform_id])
		@script = Script.find(params[:script_id])
		@micro = @inform.micros.build
		@micro.user_id = current_user.id
		@micro.description = @script.description
		
		@micro.save

		@diagnostic = @inform.diagnostics.build
		@diagnostic.user_id = current_user.id
		@diagnostic.description = @script.diagnostic
		@diagnostic.diagcode_id = Diagcode.where(pss_code: @script.pss_code).first.id
		@diagnostic.pss_code = @script.pss_code
		@diagnostic.who_code = @script.who_code

		@diagnostic.save

		@automatics = []
		# @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
		Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
		  Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
		    @automatics << auto
		  end
		end

		# También hay que enviar diagcodes por lo que micro.js también despliega los diagnostics
		@diagcodes = []
		# @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
		Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
		  o_code = Organ.where(organ: sample.organ_code).first.organ_code.to_i
		  Diagcode.where(organ_code: o_code).each do |diagcode|
		  	if diagcode.pss_code != nil
		  	  diagcode.description = diagcode.pss_code.to_s + " - " + diagcode.description.to_s 
		  	else
		  	  diagcode.description = " ---- " + diagcode.description.to_s + " ---- "
		  	end
		  	@diagcodes << diagcode
		  end
		end

		@edit_status = false
		

	end

	private
		def get_nomen(str)
			return str.split('-',2)[1].split('-',2)[1]
		end

	  def generate_rec_tag
	    next_number = 1
	    answer = false
	    if @inform.recipients.empty?
	      return @inform.tag_code + '-R1'
	    end

	    @inform.recipients.length.times {
	      @inform.recipients.each do |rec|
	        if (rec.tag == @inform.tag_code + '-R' + next_number.to_s)
	          next_number = next_number + 1
	          break
	        end
	      end
	    }
	    
	    return @inform.tag_code + '-R' + next_number.to_s
	  end

	  def generate_number_tag(sample)
	    if sample.sample_tag[-1] =~ /[A-Z]/
	      # sample.update(sample_tag: sample.sample_tag + '1')
	      return sample.sample_tag + '2'
	    end
	    if sample.sample_tag[-1] =~ /[0-9]/
	      return sample.sample_tag[0..-2] + (sample.sample_tag[-1].to_i + 1).to_s
	    end
	  end

	  def generate_letter_tag(inform)
	    next_letter = 'A'
	    answer = false
	    if inform.samples.empty?
	      return inform.tag_code + '-A'
	    end

	    inform.samples.length.times {
	      inform.samples.each do |sample|
	        if (sample.sample_tag == inform.tag_code + '-' + next_letter) || (sample.sample_tag == inform.tag_code + '-' + next_letter + '1')
	          next_letter = (next_letter.ord + 1).chr
	          break
	        end
	      end
	    }
	    
	    return inform.tag_code + '-' + next_letter
	  end
end
