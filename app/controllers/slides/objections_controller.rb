class Slides::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Slide.find(params[:slide_id])
			
		end
end