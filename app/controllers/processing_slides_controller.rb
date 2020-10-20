class ProcessingSlidesController < ApplicationController
	before_action :authenticate_user!
	
	def coloring_slides
		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @slidesc = Slide.where(created_at: date_range, colored: true)
		  @slides_first_batch = Slide.where(created_at: date_range, colored: false).limit(30)
		  @slides_rest = Slide.where(created_at: date_range, colored: false).offset(30)
		else
		  @slidesc = Slide.where(colored: true)
		  @slides_first_batch = Slide.where(colored: false).limit(30)
		  @slides_rest = Slide.where(colored: false).offset(30)
		end
	end

	def covering_slides
		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @slidesc = Slide.where(created_at: date_range, colored: true, covered: true)
		  @slides_first_batch = Slide.where(created_at: date_range, colored: true, covered: false).limit(30)
		  @slides_rest = Slide.where(created_at: date_range, colored: true, covered: false).offset(30)
		else
		  @slidesc = Slide.where(colored: true, covered: true)
		  @slides_first_batch = Slide.where(colored: true, covered: false).limit(30)
		  @slides_rest = Slide.where(colored: true, covered: false).offset(30)
		end
	end

	def tagging_slides
		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @slidesc = Slide.where(created_at: date_range, colored: true, covered: true, tagged: true)
		  @slides_first_batch = Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).limit(30)
		  @slides_rest = Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).offset(30)
		else
		  @slidesc = Slide.where(colored: true, covered: true, tagged: true)
		  @slides_first_batch = Slide.where(colored: true, covered: true, tagged: false).limit(30)
		  @slides_rest = Slide.where(colored: true, covered: true, tagged: false).offset(30)
		end
	end
end
