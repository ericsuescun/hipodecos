class ReportsController < ApplicationController
  def status

  	date_range = Date.parse(params[:init_date]).beginning_of_day..Date.parse(params[:final_date]).end_of_day
  	@informs = Inform.where(created_at: date_range)
  end

  def objections
  	date_range = Date.parse(params[:init_date]).beginning_of_day..Date.parse(params[:final_date]).end_of_day
  	@objections = Objection.where(created_at: date_range)
  end

  def sales
  end
end
