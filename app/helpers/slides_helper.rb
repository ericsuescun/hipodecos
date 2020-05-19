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

	def get_color(sample)
		# return "rgba(255,0,0,0.1)"
		if sample == nil
			return "white"
		end

		if sample.organ_code != nil
			if Organ.where(organ: sample.organ_code).first.part == "Circulatorio"
				return "rgba(255,0,0,0.4)"
			end
			
			if Organ.where(organ: sample.organ_code).first.part == "Linfatico"
				return "white"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Respiratorio"
				return "rgba(0,0,255,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Reticulo Endotelial"
				return "rgba(255,0,255,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Digestivo"
				return "rgba(255,255,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Urinario"
				return "rgba(255,150,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Genital Masculino"
				return "rgba(0,0,255,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Genital Femenino"
				return "rgba(255,150,255,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Endocrino"
				return "rgba(0,0,255,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Nervioso"
				return "rgba(0,255,0,0.6)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Sentidos"
				return "rgba(255,255,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Piel"
				return "pink"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Musculo"
				return "rgba(255,150,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Osteoarticular"
				return "rgba(0,0,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Dientes"
				return "rgba(0,0,0,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "SIDA"
				return "rgba(255,150,255,0.4)"
			end
			if Organ.where(organ: sample.organ_code).first.part == "Generales"
				return "rgba(0,255,0,0.4)"
			end
		else
			return "white"
		end
	end
end
