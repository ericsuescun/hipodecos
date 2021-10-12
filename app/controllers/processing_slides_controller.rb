class ProcessingSlidesController < ApplicationController
	before_action :authenticate_user!
	
	def coloring_slides
		@tab = :color

		@slidesc = []
		@slides_first_batch = Slide.not_colored.not_covered.not_tagged.joins(:inform).merge(Inform.where(inf_type: params[:inf_type])).limit(90)
		@slides_rest = Slide.not_colored.joins(:inform).merge(Inform.where(inf_type: params[:inf_type])).offset(90)
	end

	def covering_slides
		@tab = :cover

		@slidesc = []
		@slides_first_batch = Slide.colored.not_covered.not_tagged.joins(:inform).merge(Inform.where(inf_type: params[:inf_type])).limit(90)
		@slides_rest = Slide.not_colored.joins(:inform).merge(Inform.where(inf_type: params[:inf_type])).offset(90)
	end

	def tagging_slides
		@tab = :tag
		
		@slidesc = []
		@slides_first_batch = Slide.colored.covered.not_tagged.joins(:inform).merge(Inform.where(inf_type: params[:inf_type])).limit(90)
		@slides_rest = Slide.not_colored.joins(:inform).merge(Inform.where(inf_type: params[:inf_type])).offset(90)
	end
end
