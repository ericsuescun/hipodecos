class Macros::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Macro.find(params[:macro_id])
		end
end