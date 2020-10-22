class ResultsController < ApplicationController
	before_action :authenticate_patient!

	def index
		@patient = current_patient
		@informs = @patient.informs
		@oldrecords = Oldrecord.where(patient_id: current_patient.id)
	end

	def show

		@inform = Inform.find(params[:id])
	  	@pathologists = []
	  	@inform.diagnostics.each do |diagnostic|
	    	@pathologists << User.where(id: diagnostic.user_id).first
	  	end
	  	@pathologists = @pathologists.uniq

	end

	def show_oldrecord
		if current_patient.id == Oldrecord.where(id: params[:id]).first.patient_id
			@oldrecord = Oldrecord.find(params[:id])
			@patient = Patient.find(@oldrecord.patient_id)
		else
			render :not_permitted
		end
		
	end

	def not_permitted
		
	end

end
