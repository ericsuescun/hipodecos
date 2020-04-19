class Recipients::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Recipient.find(params[:recipient_id])
			
		end
end