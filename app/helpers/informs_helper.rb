module InformsHelper

	def user(model)
		User.find(model.user_id)
	end

end
