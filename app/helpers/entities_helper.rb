module EntitiesHelper
	def cost
		unless @entity.cost_id == nil
			Cost.find(@entity.cost_id).name
		else
			"Sin asignar"
		end
	end

	def rate
		unless @entity.rate_id == nil
			Rate.find(@entity.rate_id).name
		else
			"Sin asignar"
		end
	end
end
