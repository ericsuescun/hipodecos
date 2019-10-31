module ObjectionsHelper

	def get_by_user(user)
		time = 0.000
		count = 0
		count_closed = 0
		@objections.each do |objection|
			if objection.responsible_user_id == user.id 
				count += 1
				if objection.closed == true
					count_closed += 1
					time = objection.updated_at - objection.created_at + time
				end
			end
		end
		unless count_closed == 0
			return [count, count - count_closed, count_closed, (time / count_closed)]
		else
			return [count, count - count_closed, count_closed, 0]
		end
	end

	def get_by_process(objections)
		time = 0.000
		count = 0
		count_closed = 0
		objections.each do |objection|
			count += 1
			if objection.closed == true
				count_closed += 1	#Cada Objection que es cerrada
				time = objection.updated_at - objection.created_at + time
			end
		end
		unless count_closed == 0
			return [count, count - count_closed, count_closed, (time / count_closed)]
		else
			return [count, count - count_closed, count_closed, 0]
		end
	end

	def color(average)
		if average > 1800
			"danger"
		elsif average > 900
			"warning"
		elsif average > 1
			"success"
		elsif average == 0
				"dark"
		end
	end

end
