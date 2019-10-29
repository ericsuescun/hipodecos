class Studies::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Study.find(params[:study_id])
		end
end