class ResultsController < ApplicationController
	before_action :authenticate_patient!

	def index
		@patient = current_patient
		@informs = @patient.informs.where(inf_status: "published").or(@patient.informs.where(inf_status: "downloaded"))
		@oldrecords = Oldrecord.where(patient_id: current_patient.id)
	end

	def show
		if current_patient.id == Inform.where(id: params[:id]).first.patient.id
				@inform = Inform.find(params[:id])
			  	@pathologists = []
			  	@inform.diagnostics.each do |diagnostic|
			    	@pathologists << User.where(id: diagnostic.user_id).first
			  	end
			  	@pathologists = @pathologists.uniq
			  	if @inform.inf_status != "downloaded"
			  		@inform.update(inf_status: "downloaded", download_date: Time.now)
			  	end
		else
			render :not_permitted
		end
		

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
