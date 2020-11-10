module ApplicationHelper

	def day_before_search(n)	#Day by day
		"?di=" + n.day.ago.day.to_s + "&mi=" + n.day.ago.month.to_s + "&yi=" + n.day.ago.year.to_s + "&df=" + n.day.ago.day.to_s + "&mf=" + n.day.ago.month.to_s + "&yf=" + n.day.ago.year.to_s
	end

	def days_ago_search(n)	#Days accumulated
		"?di=" + (Date.today - n).day.to_s + "&mi=" + (Date.today - n).month.to_s + "&yi=" + (Date.today - n).year.to_s + "&df=" + Date.today.day.to_s + "&mf=" + Date.today.month.to_s + "&yf=" + Date.today.year.to_s
	end

	def week_before_search(n)
		"?di=" + n.week.ago.beginning_of_week.day.to_s + "&mi=" + n.week.ago.beginning_of_week.month.to_s + "&yi=" + n.week.ago.beginning_of_week.year.to_s + "&df=" + n.week.ago.end_of_week.day.to_s + "&mf=" + n.week.ago.end_of_week.month.to_s + "&yf=" + n.week.ago.end_of_week.year.to_s
	end

	def month_before_search(n)	#Month before
		"?di=" + (n.month.ago).beginning_of_month.day.to_s + "&mi=" + (n.month.ago).month.to_s + "&yi=" + (n.month.ago).year.to_s + "&df=" + (n.month.ago).end_of_month.day.to_s + "&mf=" + (n.month.ago).month.to_s + "&yf=" + (n.month.ago).year.to_s
	end

	def search_range
		if params[:yi]
			date_init = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i)
			date_final = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i)

			if date_init == date_final
				"en " + date_init.strftime('%b %d de %Y')
			else
				"entre " + date_init.strftime('%b %d de %Y') + " y " + date_final.strftime('%b %d de %Y')
			end
		end
		
	end

	def new_search_range
		if params[:init_date]
			init_date = Date.parse(params[:init_date])
			final_date = Date.parse(params[:final_date])

			if init_date == final_date
				"en " + final_date.strftime('%b %d de %Y')
			else
				"entre " + init_date.strftime('%b %d de %Y') + " y " + final_date.strftime('%b %d de %Y')
			end
		else
			"durante el último día."
		end
	end

	def objection_title(id)
		Obcode.where(id: id).first.try(:title)
	end

	def fix_accent(descr)

		if descr
			descr.gsub!("Ã\u009F","á")
			
			descr.gsub!("Ã\u009A","é")
			
			descr.gsub!("Ã\u009D","í")

			descr.gsub!("Â¾","ó")

			descr.gsub!("Ã\u008B","Ó")

			descr.gsub!("Â·", "ú")
		end
		return descr
	end

	def next_inform(type)
		init_date =  Time.now.beginning_of_year
		final_date = Time.now.end_of_year
		date_range = init_date..final_date

		if type == "clin"
		   consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1
		   return "C" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
		else
		 if type == "hosp"
		   consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1
		   return "H" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
		 else
		   consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1
		   return "K" + Date.today.strftime('%y').to_s + '-' + consecutive.to_s
		 end
		end
	end
	
end
