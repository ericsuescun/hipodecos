module SamplesHelper
	def take_inf
		Inform.find(@inf)
	end

	def objection_title(id)
		Obcode.find(id).title
	end
end
