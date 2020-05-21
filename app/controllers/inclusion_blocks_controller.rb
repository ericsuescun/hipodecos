class InclusionBlocksController < ApplicationController

	def inclusion
		if params[:yi] != nil
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		else
		  @blocks = Block.unscoped.all.select(:inform_id).group(:inform_id).distinct
		end

		if params[:yi] != nil
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @samplesc = Sample.where(created_at: date_range, name: "Cassette")
		else
		  @samplesc = Sample.where(name: "Cassette")
		end
	end

	def block_fp1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i + 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		get_blocks
	end

	def block_fm1
		@sample = Sample.find(params[:sample_id])
		@block = Block.find(params[:block_id])
		@block.update(fragment: params[:fragment].to_i - 1, user_id: current_user.id)
		@inform = @block.inform
		@samplesc = @inform.samples.where(name: "Cassette")
		get_blocks
	end

	def get_blocks
		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @blocks = Block.unscoped.where(created_at: date_range).select(:inform_id).group(:inform_id).distinct
		else
		  @blocks = Block.unscoped.all.select(:inform_id).group(:inform_id).distinct
		end

		if params[:yi] != ""
		  initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
		  final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
		  date_range = initial_date..final_date
		  @samplesc = Sample.where(created_at: date_range, name: "Cassette")
		else
		  @samplesc = Sample.where(name: "Cassette")
		end
	end
end
