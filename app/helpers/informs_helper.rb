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
		return answer
	end
end
