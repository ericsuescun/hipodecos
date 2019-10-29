class Macros::PicturesController < PicturesController
	before_action :set_imageable

	private
		def set_imageable
			@imageable = Macro.find(params[:macro_id])
		end
end