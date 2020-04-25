module InformsHelper
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
end







