class ProcessingSlidesController < ApplicationController
	def coloring_slides
		if params[:yi]
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @slides = Slide.where(created_at: date_range)
		else
		  @slides = Slide.all
		end
		create_matrix(@slides, 5)	#Creo la matriz con la collection de @slides correspondiente
	end

	def create_matrix(collection, rows)
		@matrix = []
		col = []
		i = 0
		collection.each do |element|
			col << element
			i = i + 1
			if i == rows
				@matrix << col
				col = []
				i = 0
			end
		end
		@matrix << col
	end
end
