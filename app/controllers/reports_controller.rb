class ReportsController < ApplicationController
  def status
  	date_range = (Date.today - 7).beginning_of_day..Date.today.end_of_day
  	@informs = Inform.where(created_at: date_range)
  end

  def objections
  	date_range = (Date.today - 7).beginning_of_day..Date.today.end_of_day
  	@objections = Objection.where(created_at: date_range)
  end

  def sales
  end
end
