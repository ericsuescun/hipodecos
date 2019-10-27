module BranchesHelper
	def infos(branch)
		this_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		last_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		Inform.where(created_at: this_month, branch_id: branch).count
	end

	def studs(branch)
		this_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		last_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		studies_count = 0
		Inform.where(created_at: this_month, branch_id: branch).each do |inform|
			studies_count += inform.studies.count
		end
		studies_count
	end

	def costos(branch)
		this_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		last_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		costs_acc = 0
		Inform.where(created_at: this_month, branch_id: branch).each do |inform|
			inform.studies.each do |study|
				costs_acc += (Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value * study.factor.to_d)
			end
		end
		costs_acc
	end

	def prices(branch)
		this_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		last_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		prices_acc = 0
		Inform.where(created_at: this_month, branch_id: branch).each do |inform|
			inform.studies.each do |study|
				prices_acc += (Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value * study.factor.to_d) * Factor.where(codeval_id: study.codeval_id, rate_id: branch.entity.rate_id).first.factor
			end
		end
		prices_acc
	end

	def studies2
		this_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		last_month = Date.today.beginning_of_month..Date.today.end_of_month.end_of_day
		answer = []
		Inform.where(created_at: this_month, branch_id: @branch.id).each do |inform|
			inform.studies.each do |study|
				answer << study
			end
		end
		answer
	end
end
