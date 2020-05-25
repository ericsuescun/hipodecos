module ProcessingSlidesHelper
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
end
