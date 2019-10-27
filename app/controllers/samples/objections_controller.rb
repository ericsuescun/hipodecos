class Samples::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Sample.find(params[:sample_id])
			
		end
end