module AutomaticsHelper
	def organ_list
		Organ.unscoped.order(organ: :asc)
	end
end
