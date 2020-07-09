class ResultsController < ApplicationController
	before_action :authenticate_patient!

	def index
		@patient = current_patient
		@informs = @patient.informs
	end

	def show
		@inform = Inform.find(params[:id])
	  	@pathologists = []
	  	@inform.diagnostics.each do |diagnostic|
	    	@pathologists << User.where(id: diagnostic.user_id).first
	  	end
	  	@pathologists = @pathologists.uniq
	end

end
