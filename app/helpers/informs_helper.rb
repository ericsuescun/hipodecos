module InformsHelper
	def branch
		Branch.find(@inform.branch_id).initials
	end

	def promoter
		Promoter.find(@inform.promoter_id).initials
	end
end
