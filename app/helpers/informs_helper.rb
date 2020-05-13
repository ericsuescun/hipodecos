module InformsHelper

	def get_price(study)
		inform = Inform.find(study.inform_id)
		branch = Branch.find(inform.branch_id)
		cost = Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value
		profit_margin = Factor.where(codeval_id: study.codeval_id, rate_id: branch.entity.rate_id).first.factor
		price = cost * profit_margin
		return price
	end

	def get_rate_name(study)
		inform = Inform.find(study.inform_id)
		branch = Branch.find(inform.branch_id)
		entity = branch.entity
		rate = Rate.find(entity.rate_id)
		return rate.name
	end

	def get_slides_samples(slide)
		if slide.slide_tag[-1] == "*"
			return Sample.where(inform_id: slide.inform.id, sample_tag: slide.slide_tag[0..-2])
		else
			return Sample.where(inform_id: slide.inform.id, slide_tag: slide.slide_tag)
		end
	end

	def get_nomen(str)
		return str.split('-',2)[1].split('-',2)[1]
	end

	def getcodes(inform)
		find = inform.micros.first.description
		if find == nil
			return []
		end
		find = find.downcase.gsub(/[^a-z0-9\s]/i, '')
		a = find.split(" ")
		b = []
		a.each do |n|
			if n.length > 3
				b << n
			end
		end
		answer = []
		# word = b[0]
		# answer += Diagcode.where("description like ?", "%#{word}%")
		b.each do |word|
			answer += Diagcode.where("description like ?", "%#{word.upcase}%")
		end
		# answer = answer.sort_by(&:organ)
		return answer
	end

	# def generate_letter_tag(inform)
	# 	next_letter = 'A'
	# 	inform.samples.each do |sample|
	# 		a = sample.sample_tag[-1] == inform.tag_code + (next_letter.ord + 1).chr
	# 		b = sample.sample_tag[-2] == inform.tag_code + (next_letter.ord + 1).chr
	# 		if a || b
	# 			next_letter = (next_letter.ord + 1).chr
	# 		end
	# 		if true
	# 			return true
	# 		end
	# 	end
	# 	return inform.tag_code + (next_letter.ord + 1).chr
	# end

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

	def generate_number_tag(sample)
		if sample.sample_tag[-1] =~ /[A-Z]/
			# sample.update(sample_tag: sample.sample_tag + '1')
			return sample.sample_tag + '2'
		end
		if sample.sample_tag[-1] =~ /[0-9]/
			return sample.sample_tag[0..-2] + (sample.sample_tag[-1].to_i + 1).to_s
		end
	end

	def next_number_tag_exists?(inform, sample)
		answer = false
		inform.samples.each do |s|
			if generate_number_tag(sample) == s.sample_tag	#Si el tag que le sige a sample lo encuentro en otro sample de inform
				answer = answer | true
			end
		end
		return answer
	end

	def extract_part		
		return ['Circulatorio', 'Linfatico', 'Respiratorio', 'Reticulo Endotelial', 'Digestivo', 'Urinario', 'Genital Masculino', 'Genital Femenino', 'Endocrino', 'Nervioso', 'Sentidos', 'Piel', 'Musculo', 'Osteoarticular', 'Dientes', 'SIDA', 'Generales']
	end

	def get_color(sample)
		# return "rgba(255,0,0,0.1)"

		if sample.organ_code != nil
			if Organ.where(organ: sample.organ_code).first.part == "Circulatorio"
				return "rgba(255,0,0,0.1)"
			end
			
			if Organ.where(organ: sample.organ_code).first.part == "Linfatico"
				return "white"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Respiratorio"
				return "rgba(0,0,255,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Reticulo Endotelial"
				return "rgba(255,0,255,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Digestivo"
				return "rgba(255,255,0,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Urinario"
				return "rgba(255,150,0,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Genital Masculino"
				return "rgba(0,0,255,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Genital Femenino"
				return "rgba(255,150,255,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Endocrino"
				return "rgba(255,150,255,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Nervioso"
				return "rgba(0,255,0,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Sentidos"
				return "rgba(255,255,0,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Piel"
				return "pink"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Musculo"
				return "rgba(255,150,0,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Osteoarticular"
				return "rgba(0,0,0,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Dientes"
				return "rgba(0,0,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "SIDA"
				return "rgba(0,0,255,0.1)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Generales"
				return "rgba(0,255,0,0.1)"
			end
		else
			return "white"
		end
	end

	def get_autocolor(automatic)
		# n "rgba(255,0,0,0.1)"

		if automatic.organ != nil
			if Organ.where(organ: automatic.organ).first.part == "Circulatorio"
				return "rgba(255,0,0,0.1)"
			end
			
			if Organ.where(organ: automatic.organ).first.part == "Linfatico"
				return "white"
			end
			if Organ.where(organ: automatic.organ).first.part == "Respiratorio"
				return "rgba(0,0,255,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Reticulo Endotelial"
				return "rgba(255,0,255,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Digestivo"
				return "rgba(255,255,0,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Urinario"
				return "rgba(255,150,0,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Genital Masculino"
				return "rgba(0,0,255,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Genital Femenino"
				return "rgba(255,150,255,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Endocrino"
				return "rgba(255,150,255,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Nervioso"
				return "rgba(0,255,0,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Sentidos"
				return "rgba(255,255,0,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Piel"
				return "pink"
			end
			if Organ.where(organ: automatic.organ).first.part == "Musculo"
				return "rgba(255,150,0,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Osteoarticular"
				return "rgba(0,0,0,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Dientes"
				return "rgba(0,0,0,0.4)"
			end
			if Organ.where(organ: automatic.organ).first.part == "SIDA"
				return "rgba(0,0,255,0.1)"
			end
			if Organ.where(organ: automatic.organ).first.part == "Generales"
				return "rgba(0,255,0,0.1)"
			end
		else
			return "white"
		end
	end
end







