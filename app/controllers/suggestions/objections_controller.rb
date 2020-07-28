class Suggestions::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Sugestion.find(params[:suggestion_id])
			
		end
end