class ListSlidesController < ApplicationController
	def color
		@slide = Slide.find(params[:slide_id])
		@slide.update(colored: !@slide.colored)
		get_slides
	end

	def tag
		@slide = Slide.find(params[:slide_id])
		@slide.update(tagged: !@slide.tagged)
		get_slides
	end

	def cover
		@slide = Slide.find(params[:slide_id])
		@slide.update(covered: !@slide.covered)
		get_slides
	end

	def get_slides
		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @slides = Slide.where(created_at: date_range).select(:id, :inform_id, :user_id, :created_at, :description, :slide_tag, :colored, :tagged, :covered, :stored).group(:id, :inform_id)
		else
		  @slides = Slide.all.select(:id, :inform_id, :user_id, :created_at, :description, :slide_tag, :colored, :tagged, :covered, :stored).group(:id, :inform_id)
		end
	end
end
