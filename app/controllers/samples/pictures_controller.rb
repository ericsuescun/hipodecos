class Samples::PicturesController < PicturesController
	before_action :set_imageable

	private
		def set_imageable
			@imageable = Sample.find(params[:sample_id])
		end
end