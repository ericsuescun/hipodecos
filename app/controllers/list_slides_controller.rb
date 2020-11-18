class ListSlidesController < ApplicationController
	before_action :authenticate_user!
	
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
		# if params[:yi] != ""
		#   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		#   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		#   date_range = initial_date..final_date
		#   @slides = Slide.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		# else
		#   @slides = Slide.unscoped.all.select(:inform_id).group(:inform_id).distinct
		# end

		if params[:init_date]
		  initial_date = Date.parse(params[:init_date]).beginning_of_day
		  final_date = Date.parse(params[:final_date]).end_of_day
		  date_range = initial_date..final_date
		else
		  initial_date = 1.day.ago.beginning_of_day
		  final_date = Time.now.end_of_day
		  date_range = initial_date..final_date
		end
		@slides = Slide.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
	end
end
