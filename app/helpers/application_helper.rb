module ApplicationHelper

	def day_before_search(n)	#Day by day
		"?di=" + n.day.ago.day.to_s + "&mi=" + n.day.ago.month.to_s + "&yi=" + n.day.ago.year.to_s + "&df=" + n.day.ago.day.to_s + "&mf=" + n.day.ago.month.to_s + "&yf=" + n.day.ago.year.to_s
	end

	def days_ago_search(n)	#Days accumulated
		"?di=" + (Date.today - n).day.to_s + "&mi=" + (Date.today - n).month.to_s + "&yi=" + (Date.today - n).year.to_s + "&df=" + Date.today.day.to_s + "&mf=" + Date.today.month.to_s + "&yf=" + Date.today.year.to_s
	end

	def month_before_search(n)	#Month before
		"?di=" + (n.month.ago).beginning_of_month.day.to_s + "&mi=" + (n.month.ago).month.to_s + "&yi=" + (n.month.ago).year.to_s + "&df=" + (n.month.ago).end_of_month.day.to_s + "&mf=" + (n.month.ago).month.to_s + "&yf=" + (n.month.ago).year.to_s
	end
	
end
