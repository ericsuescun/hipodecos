class Micros::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Micro.find(params[:micro_id])
			
		end
end