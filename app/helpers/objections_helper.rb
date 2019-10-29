module ObjectionsHelper

	def get_by_user(user)
		count = 0
		@objections.each do |objection|
			if objection.responsible_user_id == user.id 
				count += 1
			end
		end
		return count
	end

	def avg_review(modelos)
		time = 0.000
		count = 0
		modelos.each do |modelo|
			modelo.objections.each do |objection|
				if objection.closed == true
					count += 1	#Cada Objection que es cerrada
					time = objection.updated_at - objection.created_at + time
				end
			end
		end
		unless count == 0
			return (time / count)
		else
			return 0
		end
	end
	
end
