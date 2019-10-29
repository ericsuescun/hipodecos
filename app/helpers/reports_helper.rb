module ReportsHelper
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

	def objs(modelo)
		objs = 0
		objsopen = 0
		modelo.each do |md|
			objs = objs + md.objections.count
			md.objections.each do |n|
				if n.closed == false
					objsopen += 1
				end
			end
		end
		return objs > 0 ? " #{objs - objsopen}/#{objs} " : nil
	end

end
