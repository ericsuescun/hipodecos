module SlidesHelper
	def get_slides_samples(slide)
		if slide.slide_tag[-1] == "*"
			return Sample.where(inform_id: slide.inform.id, sample_tag: slide.slide_tag[0..-2], name: "Extendido")
		else
			return Sample.where(inform_id: slide.inform.id, slide_tag: slide.slide_tag, name: "Extendido")
		end
	end

	def get_slides_blocks(slide)
		if slide.slide_tag[-1] == "*"
			return Block.where(inform_id: slide.inform.id, block_tag: slide.slide_tag[0..-2])
		else
			return Block.where(inform_id: slide.inform.id, slide_tag: slide.slide_tag)
		end
	end
end
