class ProcessingSlidesController < ApplicationController
	before_action :authenticate_user!
	
	def coloring_slides
		@tab = :color
		# if params[:yi]
		#   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		#   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		#   date_range = initial_date..final_date
		#   @slidesc = Slide.where(created_at: date_range, colored: true)
		#   @slides_first_batch = Slide.where(created_at: date_range, colored: false).limit(30)
		#   @slides_rest = Slide.where(created_at: date_range, colored: false).offset(30)
		# else
		#   @slidesc = Slide.where(colored: true)
		#   @slides_first_batch = Slide.where(colored: false).limit(30)
		#   @slides_rest = Slide.where(colored: false).offset(30)
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

		# @slidesc = Slide.where(created_at: date_range, colored: true)
		@slidesc = []
		Slide.where(created_at: date_range, colored: true).each do |slide|
			if params[:inf_type] == "clin" || params[:inf_type] == "hosp"
				@slidesc << slide if slide.slide_tag[0] == 'C' || slide.slide_tag[0] == 'H'
			else
				@slidesc << slide if slide.slide_tag[0] == 'K'
			end
			
		end

		# @slides_first_batch = Slide.where(created_at: date_range, colored: false).limit(30)
		@slidesnc = []
		Slide.where(created_at: date_range, colored: false).each do |slide|
			if params[:inf_type] == "clin" || params[:inf_type] == "hosp"
				@slidesnc << slide if slide.slide_tag[0] == 'C' || slide.slide_tag[0] == 'H'
			else
				@slidesnc << slide if slide.slide_tag[0] == 'K'
			end
		end
		@slides_first_batch = @slidesnc[0..29]
		if @slides_first_batch == nil
			@slides_first_batch = []
		end

		# @slides_rest = Slide.where(created_at: date_range, colored: false).offset(30)
		@slides_rest = @slidesnc[30..-1]
		if @slides_rest == nil
			@slides_rest = []
		end
	end

	def covering_slides
		@tab = :cover
		# if params[:yi]
		#   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		#   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		#   date_range = initial_date..final_date
		#   @slidesc = Slide.where(created_at: date_range, colored: true, covered: true)
		#   @slides_first_batch = Slide.where(created_at: date_range, colored: true, covered: false).limit(30)
		#   @slides_rest = Slide.where(created_at: date_range, colored: true, covered: false).offset(30)
		# else
		#   @slidesc = Slide.where(colored: true, covered: true)
		#   @slides_first_batch = Slide.where(colored: true, covered: false).limit(30)
		#   @slides_rest = Slide.where(colored: true, covered: false).offset(30)
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
		# @slidesc = Slide.where(created_at: date_range, colored: true, covered: true)
		# @slides_first_batch = Slide.where(created_at: date_range, colored: true, covered: false).limit(30)
		# @slides_rest = Slide.where(created_at: date_range, colored: true, covered: false).offset(30)

		@slidesc = []
		Slide.where(created_at: date_range, colored: true, covered: true).each do |slide|
			if params[:inf_type] == "clin" || params[:inf_type] == "hosp"
				@slidesc << slide if slide.slide_tag[0] == 'C' || slide.slide_tag[0] == 'H'
			else
				@slidesc << slide if slide.slide_tag[0] == 'K'
			end
			
		end

		@slidesnc = []
		Slide.where(created_at: date_range, colored: true, covered: false).each do |slide|
			if params[:inf_type] == "clin" || params[:inf_type] == "hosp"
				@slidesnc << slide if slide.slide_tag[0] == 'C' || slide.slide_tag[0] == 'H'
			else
				@slidesnc << slide if slide.slide_tag[0] == 'K'
			end
		end
		@slides_first_batch = @slidesnc[0..29]
		if @slides_first_batch == nil
			@slides_first_batch = []
		end

		@slides_rest = @slidesnc[30..-1]
		if @slides_rest == nil
			@slides_rest = []
		end
	end

	def tagging_slides
		@tab = :tag
		# if params[:yi]
		#   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		#   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		#   date_range = initial_date..final_date
		#   @slidesc = Slide.where(created_at: date_range, colored: true, covered: true, tagged: true)
		#   @slides_first_batch = Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).limit(30)
		#   @slides_rest = Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).offset(30)
		# else
		#   @slidesc = Slide.where(colored: true, covered: true, tagged: true)
		#   @slides_first_batch = Slide.where(colored: true, covered: true, tagged: false).limit(30)
		#   @slides_rest = Slide.where(colored: true, covered: true, tagged: false).offset(30)
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
		# @slidesc = Slide.where(created_at: date_range, colored: true, covered: true, tagged: true)
		# @slides_first_batch = Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).limit(30)
		# @slides_rest = Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).offset(30)

		@slidesc = []
		Slide.where(created_at: date_range, colored: true, covered: true, tagged: true).each do |slide|
			if params[:inf_type] == "clin" || params[:inf_type] == "hosp"
				@slidesc << slide if slide.slide_tag[0] == 'C' || slide.slide_tag[0] == 'H'
			else
				@slidesc << slide if slide.slide_tag[0] == 'K'
			end
			
		end

		@slidesnc = []
		Slide.where(created_at: date_range, colored: true, covered: true, tagged: false).each do |slide|
			if params[:inf_type] == "clin" || params[:inf_type] == "hosp"
				@slidesnc << slide if slide.slide_tag[0] == 'C' || slide.slide_tag[0] == 'H'
			else
				@slidesnc << slide if slide.slide_tag[0] == 'K'
			end
		end
		@slides_first_batch = @slidesnc[0..29]
		if @slides_first_batch == nil
			@slides_first_batch = []
		end

		@slides_rest = @slidesnc[30..-1]
		if @slides_rest == nil
			@slides_rest = []
		end
	end
end
