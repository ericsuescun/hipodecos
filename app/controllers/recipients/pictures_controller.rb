class Recipients::PicturesController < PicturesController
	before_action :set_imageable

	private
		def set_imageable
			@imageable = Recipient.find(params[:recipient_id])
		end
end