module ReportsHelper
	# Builds the sales/billing worksheet into the given caxlsx package. Lives in a
	# helper (not a partial) because caxlsx_rails gives each `.axlsx` template its
	# own package, so a package passed across a partial boundary is not the one it
	# serializes; a helper runs in the view context and mutates the caller's
	# package directly. Reads the same ivars the HTML views use (@entity,
	# @total_detail from build_sale_report, @codeval_map, @promoter_map) so the
	# sheet stays in lock-step with the on-screen report.
	def sales_xlsx_sheet(xlsx_package)
		wb = xlsx_package.workbook
		s  = wb.styles

		report_type = params[:inf_type] == 'clin' ? 'Clínica' : params[:inf_type] == 'hosp' ? 'Hospital' : 'Citologías'

		title_style    = s.add_style(b: true, sz: 14)
		subtitle_style = s.add_style(sz: 11, fg_color: '595959')
		header_style   = s.add_style(b: true, bg_color: '1F4E78', fg_color: 'FFFFFF',
		                             alignment: { horizontal: :center, vertical: :center },
		                             border: { style: :thin, color: '999999' })
		cell_style     = s.add_style(border: { style: :thin, color: 'DDDDDD' })
		money_style    = s.add_style(format_code: '#,##0', border: { style: :thin, color: 'DDDDDD' },
		                             alignment: { horizontal: :right })
		subtotal_lbl   = s.add_style(b: true, bg_color: 'FCE4D6')
		subtotal_val   = s.add_style(b: true, bg_color: 'FCE4D6', format_code: '#,##0',
		                             alignment: { horizontal: :right })
		total_lbl      = s.add_style(b: true, bg_color: 'DDEBF7', sz: 12)
		total_val      = s.add_style(b: true, bg_color: 'DDEBF7', sz: 12, format_code: '#,##0',
		                             alignment: { horizontal: :right })

		wb.add_worksheet(name: 'Ventas') do |sheet|
			sheet.add_row [@entity.name], style: title_style
			sheet.add_row ["#{report_type} facturadas — periodo #{params[:init_date]} a #{params[:final_date]}"],
			              style: subtitle_style
			sheet.add_row ["Sede #{params[:branch_name]}"], style: subtitle_style if params[:branch_name].present?
			sheet.add_row []

			headers = ['Sede', 'Autoriz.', 'EPS', 'Informe', 'Nombre', 'Identif.', 'CUP', 'Precio total']
			sheet.add_row headers, style: header_style

			@total_detail.each do |detail|
				if detail[1] == '--' # entity grand-total sentinel row
					sheet.add_row ['', '', '', '', '', '', 'TOTAL IPS', detail[7]],
					              style: ([total_lbl] * 7) + [total_val]
				elsif detail[2] == '**' # per-branch subtotal sentinel row
					next if detail[6] == 0
					sheet.add_row [detail[1], '', '', '', '', '', 'Total sede', detail[6]],
					              style: ([subtotal_lbl] * 7) + [subtotal_val]
				else # a real inform row
					inform = detail[2]
					cups = detail[3].map { |study| "(#{study.factor}*)#{@codeval_map[study.codeval_id]&.code}" }.join(' ')
					sheet.add_row [
						detail[1],
						inform.prmtr_auth_code,
						@promoter_map[inform.promoter_id]&.initials,
						inform.tag_code,
						inform.patient&.fullname,
						inform.patient&.id_number,
						cups,
						detail[6]
					], style: ([cell_style] * 7) + [money_style]
				end
			end

			sheet.column_widths 20, 16, 10, 12, 32, 16, 34, 14
		end
	end

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
