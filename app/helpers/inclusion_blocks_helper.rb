module InclusionBlocksHelper
	def get_nomen(str)
		return str.split('-',2)[1].split('-',2)[1]
	end
end
