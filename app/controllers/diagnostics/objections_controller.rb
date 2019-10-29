class Diagnostics::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Diagnostic.find(params[:diagnostic_id])
			
		end
end