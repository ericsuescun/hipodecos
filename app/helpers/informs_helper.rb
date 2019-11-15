module InformsHelper
	def getcodes(inform)
		find = inform.micros.first.description
		answer = Diagcode.where("description like ?", "%#{find}%")
		return answer
	end
end
