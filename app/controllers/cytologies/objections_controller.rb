class Citologies::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Cytology.find(params[:citology_id])
			
		end
end