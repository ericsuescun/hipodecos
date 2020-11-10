class SuggestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]

  # GET /suggestions
  # GET /suggestions.json
  def index
    @suggestions = Suggestion.all
  end

  # GET /suggestions/1
  # GET /suggestions/1.json
  def show
  end

  # GET /suggestions/new
  def new
    @inform = Inform.find(params[:inform_id])
  end

  # GET /suggestions/1/edit
  def edit
    @inform = @suggestion.inform
  end

  # POST /suggestions
  # POST /suggestions.json
  def create
   @inform = Inform.find(params[:inform_id])
   @suggestion = @inform.suggestions.build(suggestion_params)
   @suggestion.user_id = current_user.id

   @suggestion.save
  end

  # PATCH/PUT /suggestions/1
  # PATCH/PUT /suggestions/1.json
  def update
    @suggestion.update(suggestion_params)

    @inform = @suggestion.inform
  end

  def review
    @objection = Objection.find(params[:objection_id])
    @suggestion = Suggestion.find(params[:suggestion_id])
    @inform = @suggestion.inform
  end

  def anotate
    @objection = Objection.find(params[:objection_id])
    @suggestion = Suggestion.find(params[:suggestion_id])
    new_description = @objection.description.to_s + "FECHA: " + Date.today.to_s + " REVISIÓN: " + params[:new_description].to_s + ", por: " + current_user.email
    @objection.update(
      description: new_description,
      close_user_id: current_user.id,
      close_date: Date.today,
      closed: true
    )

    @inform = @suggestion.inform
  end

  # DELETE /suggestions/1
  # DELETE /suggestions/1.json
  def destroy
    @inform = @suggestion.inform
    @suggestion.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def suggestion_params
      params.require(:suggestion).permit(:inform_id, :user_id, :description)
    end
end
