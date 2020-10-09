class Informs::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Inform.find(params[:inform_id])
			
		end
end