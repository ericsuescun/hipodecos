# module InformsHelper
# 	def getcodes(inform)
# 		find = inform.micros.first.description
# 		answer = Diagcode.where("description like ?", "%#{find}%")
# 		return answer
# 	end
# end


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

	def generate_letter_tag(inform)
		tag_shift = inform.samples.count
		return inform.tag_code + (65 + tag_shift).chr
	end

	def generate_letter_tag2(sample)
		if sample.sample_tag[-1] =~ /[A-Z]/
			return sample.sample_tag[0..-2] + (sample.sample_tag[-1].ord + 1)
		end
	end

	def generate_number_tag(sample)
		if sample.sample_tag[-1] =~ /[A-Z]/
			sample.update(sample_tag: sample.sample_tag + '1')
			return sample.sample_tag + '2'
		end
		if sample.sample_tag[-1] =~ /[0-9]/
			return sample.sample_tag[0..-2] + (sample.sample_tag[-1].to_i + 1).to_s
		end
	end

	def next_number_tag_exists?(inform, sample)
		inform.samples.each do |s|
			if s.sample_tag == generate_number_tag(sample)
				return true
			else
				return false
			end
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
end
