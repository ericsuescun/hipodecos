module ReportsHelper
	def count_invoices(a,b)
		c = 0
		if a > 0
			c += 1
		end
		if b > 0
			c += 1
		end
		return c
	end

	def inform_status(inform)
		status = 0
		inform.physicians.count > 0 ? status += 1 : status += 0
		inform.samples.count > 0 ? status += 1 : status += 0
		inform.studies.count > 0 ? status += 1 : status += 0
		inform.blocks.count > 0 ? status += 1 : status += 0
		inform.slides.count > 0 ? status += 1 : status += 0
		inform.macros.count > 0 ? status += 1 : status += 0
		inform.micros.count > 0 ? status += 1 : status += 0
		inform.diagnostics.count > 0 ? status += 1 : status += 0
		return (100 * status) / 8
	end

	def objs(objectionables)
		objs = 0
		objsopen = 0
		objectionables.each do |objectionable|
			objs = objs + objectionable.objections.count
			objectionable.objections.each do |objection|
				if objection.closed == false
					objsopen += 1
				end
			end
		end
		return objs > 0 ? " #{objs - objsopen}/#{objs} " : nil
	end

	def sales(branch)
		@informs.where(branch_id: branch)	# PILAS !!!! Estos @informs estan con created_at, debe ser con DELIVERED DATE!!!

		sales = 0
		@informs.where(branch_id: branch).each do |inform|
			inform.studies.each do |study|
				sales += (Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value * study.factor.to_d) * Factor.where(codeval_id: study.codeval_id, rate_id: branch.entity.rate_id).first.factor
			end
		end

		costs = 0
		@informs.where(branch_id: branch).each do |inform|
			inform.studies.each do |study|
				costs += (Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value * study.factor.to_d)
			end
		end

		studies_count = 0
		@informs.where(branch_id: branch).each do |inform|
			studies_count += inform.studies.count
		end
		

		return [ sales, costs, sales - costs, @informs.where(branch_id: branch).count, studies_count ]
	end

	def whole_sales_indexes
		sales = 0
		costs = 0
		infos = 0
		studies_count = 0

		Branch.all.each do |branch|
			@informs.where(branch_id: branch)	# PILAS !!!! Estos @informs estan con created_at, debe ser con DELIVERED DATE!!!

			
			@informs.where(branch_id: branch).each do |inform|
				inform.studies.each do |study|
					studies_count += 1
					costs += (Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value * study.factor.to_d)
					sales += (Value.where(codeval_id: study.codeval_id, cost_id: branch.entity.cost_id).first.value * study.factor.to_d) * Factor.where(codeval_id: study.codeval_id, rate_id: branch.entity.rate_id).first.factor
				end
			end

			infos += @informs.where(branch_id: branch).count

		end

		return [ sales, costs, sales - costs, infos, studies_count ]

		# if (infos != 0) && (studies_count != 0)
		# 	return [ sales, costs, sales - costs, infos, studies_count, sales / infos, costs / infos, (sales - costs) / infos, sales / studies_count, costs / studies_count, (sales - costs) / studies_count]
		# elsif (infos != 0) && (studies_count == 0)
		# 	return [ sales, costs, sales - costs, infos, studies_count, sales / infos, costs / infos, (sales - costs) / infos, 0.1, 0.1, 0.1]
		# elsif (infos == 0) && (studies_count != 0)
		# 		return [ sales, costs, sales - costs, infos, studies_count, 0.1, 0.1, 0.1, sales / studies_count, costs / studies_count, (sales - costs) / studies_count]
		# else return [ sales, costs, sales - costs, infos, studies_count, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
					
		# end
	end

end
