class ExecuteTemplatesController < ApplicationController
	before_action :authenticate_user!

	def block_fp1
		
	end

	def block_fok
		
	end

	def block_fm1
		
	end

	def create_blocks
		@inform = Inform.find(params[:inform_id])
		@samples = @inform.samples
		@samples.each do |sample|
			@inform.blocks.create(
				user_id: current_user.id,
				block_tag: sample.sample_tag,
				description: sample.description,
				organ_code: sample.organ_code,
				fragment: sample.fragment,
				slide_tag: nil
			)
		end
	end

	def add_slide
		@inform = Inform.find(params[:inform_id])
		@sample = Sample.find(params[:sample_id])
		@recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first
		@inform.slides.create(slide_tag: params[:sample_tag])	#Se crea un slide con el mismo tag de la sample
		@sample.update(slide_tag: params[:sample_tag])	#Se guarda el tag creado en la sample para que queden asociados
	end

	def add_series
		@inform = Inform.find(params[:inform_id])
		@inform.slides.create(slide_tag: params[:sample_tag] + "*")
	end

	def associate_slide
		@automatics = Automatic.all 	#Para poder renderizar recipients entero...
		@sample = Sample.find(params[:sample_id])
		@inform = @sample.inform
		@recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first

		@sample.update(slide_tag: params[:destination_slide])	#Se taggea la sample actual con el slide seleccionado

		@slide = Slide.where(inform_id: params[:inform_id], slide_tag: params[:destination_slide]).first	#Traigo el slide actual

		new_tag = @slide.slide_tag + "-" + get_nomen(@sample.sample_tag)	#Calculo el nuevo tag
		@slide.update(slide_tag: new_tag)	#Actualizo la slide con ese nuevo tag

		@samples = Inform.find(params[:inform_id]).samples.where(slide_tag: params[:destination_slide]) #Busco todas las samples de ese informe con ese slide asociado (por el tag)

		@samples.each do |sample|
			sample.update(slide_tag: new_tag)	#Actualizo todas las samples asociadas con el nuevo tag
		end
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
				@sample.recipient_tag = @recipient.tag
				@sample.sample_tag = generate_number_tag(@last_sample)
				@sample.organ_code = script.organ == "" ? nil : script.organ
				@sample.description = script.description
				@sample.fragment = script.param1
				@sample.save

				@last_sample = @sample

			when "ext"
				@sample = @inform.samples.build
				@sample.user_id = current_user.id
				@sample.name = "Extendido"
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
