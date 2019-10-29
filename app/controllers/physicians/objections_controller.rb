class Physicians::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Physician.find(params[:physician_id])
			
		end
end