class Patients::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Patient.find(params[:patient_id])
			
		end
end