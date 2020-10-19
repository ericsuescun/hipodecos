module RatesHelper
	def rate_cost(factor)
		return Value.where(codeval_id: factor.codeval_id, cost_id: factor.cost_id).first.value
	end
end
