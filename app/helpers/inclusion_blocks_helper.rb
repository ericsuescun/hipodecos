module InclusionBlocksHelper
	def get_nomen(str)
		return str.split('-',2)[1].split('-',2)[1]
	end

	def all_samples_included(s)
		inform = s.inform
		all_samples_included = true
		inform.samples.each do |sample|
			all_samples_included = all_samples_included & sample.included
		end
		return all_samples_included
	end
end
