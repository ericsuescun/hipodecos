class ListSlidesController < ApplicationController
	before_action :authenticate_user!
	
	def color
		@slide = Slide.find(params[:slide_id])
		@slide.update(colored: !@slide.colored)
		@informs = Inform.joins(:slides).merge(Slide.not_colored.not_tagged.not_covered).uniq
	end

	def tag
		@slide = Slide.find(params[:slide_id])
		@slide.update(tagged: !@slide.tagged)
		@informs = Inform.joins(:slides).merge(Slide.not_colored.not_tagged.not_covered).uniq
	end

	def cover
		@slide = Slide.find(params[:slide_id])
		@slide.update(covered: !@slide.covered)
		@informs = Inform.joins(:slides).merge(Slide.not_colored.not_tagged.not_covered).uniq
	end
end
