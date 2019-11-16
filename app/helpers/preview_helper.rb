module PreviewHelper
	def blocks_stored(inform)
		answer = false
		inform.blocks.each do |block|
			answer = answer || block.stored
		end
		return answer
	end
end