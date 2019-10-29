class Micros::PicturesController < PicturesController
	before_action :set_imageable

	private
		def set_imageable
			@imageable = Micro.find(params[:micro_id])
			
		end
end