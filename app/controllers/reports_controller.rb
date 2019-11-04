class ReportsController < ApplicationController
  before_action :authenticate_user!

  def status
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(created_at: date_range)
    else
      @informs = Inform.all
    end
  end

  def objections
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @objections = Objection.where(created_at: date_range)

      @obj_physicians = @objections.where(objectionable_type: 'Physician')
      @obj_samples = @objections.where(objectionable_type: 'Sample')
      @obj_studies = @objections.where(objectionable_type: 'Study')
      @obj_blocks = @objections.where(objectionable_type: 'Block')
      @obj_slides = @objections.where(objectionable_type: 'Slide')
      @obj_macros = @objections.where(objectionable_type: 'Macro')
      @obj_micros = @objections.where(objectionable_type: 'Micro')
      @obj_diagnostics = @objections.where(objectionable_type: 'Diagnostic')
    else
      @objections = Objection.all

      @obj_physicians = @objections.where(objectionable_type: 'Physician')
      @obj_samples = @objections.where(objectionable_type: 'Sample')
      @obj_studies = @objections.where(objectionable_type: 'Study')
      @obj_blocks = @objections.where(objectionable_type: 'Block')
      @obj_slides = @objections.where(objectionable_type: 'Slide')
      @obj_macros = @objections.where(objectionable_type: 'Macro')
      @obj_micros = @objections.where(objectionable_type: 'Micro')
      @obj_diagnostics = @objections.where(objectionable_type: 'Diagnostic')
    end
  end

  def sales
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @branches = Branch.all
      @informs = Inform.where(created_at: date_range)
    else
      @branches = Branch.all
    end
  end

  def reports_params_today
  end

end
