module InclusionBlocksHelper
	def get_nomen(str)
		return str.split('-',2)[1].split('-',2)[1]
	end

	def all_samples_included(s)
		inform = s.inform
		all_samples_included = true
		inform.samples.where(name: "Cassette").each do |sample|
			all_samples_included = all_samples_included & sample.included
		end
		return all_samples_included
	end

	def create_matrix(collection, rows)
		matrix = []
		col = []
		i = 0
		collection.each do |element|
			col << element
			i = i + 1
			if i == rows
				matrix << col
				col = []
				i = 0
			end
		end
		matrix << col
		return matrix
	end

	def get_sample(block)
		inform = block.inform
		return inform.samples.where(name: "Cassette", sample_tag: block.block_tag).first
			
	end
end
