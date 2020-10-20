class ResultsController < ApplicationController
	before_action :authenticate_patient!

	def index
		@patient = current_patient
		@informs = @patient.informs
	end

	def show
		if current_patient.id == params[:id].to_i
			@inform = Inform.find(params[:id])
		  	@pathologists = []
		  	@inform.diagnostics.each do |diagnostic|
		    	@pathologists << User.where(id: diagnostic.user_id).first
		  	end
		  	@pathologists = @pathologists.uniq
		else
			render :not_permitted
		end
		
	end

	def not_permitted
		
	end

end
