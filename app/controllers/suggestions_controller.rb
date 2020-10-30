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
    @suggestion = Suggestion.new
  end

  # GET /suggestions/1/edit
  def edit
    @inform = @suggestion.inform
  end

  # POST /suggestions
  # POST /suggestions.json
  def create
    @suggestion = Suggestion.new(suggestion_params)

    respond_to do |format|
      if @suggestion.save
        format.html { redirect_to @suggestion, notice: 'Suggestion was successfully created.' }
        format.json { render :show, status: :created, location: @suggestion }
      else
        format.html { render :new }
        format.json { render json: @suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suggestions/1
  # PATCH/PUT /suggestions/1.json
  def update
    if params[:suggestion][:edit_su_status] == "true"
      log = ""
      if @suggestion.description != suggestion_params[:description]
        log += "FECHA: " + Date.today.to_s
        log += " CAMBIOS: "
        log += " Descripción - ANTES: " + @suggestion.description
        log += ", por: " + User.where(id: @suggestion.user_id).first.try(:email).to_s
        log += " Descripción - DESPUES: " + suggestion_params[:description].to_s
        log += ", por: " + current_user.email + " \n"

      else
        log += "FECHA: " + Date.today.to_s
        log += " SUGERENCIA SIN CAMBIOS."
      end

      #Obcode 16 corresponde a error en automatico o codigo biopsias
      @objection = @suggestion.objections.new(
        responsible_user_id: @suggestion.user_id,
        user_id: current_user.id,
        description: log,
        obcode_id: 16,
        close_user_id: nil,
        closed: false
      ) 
      #@objectionable se crea en una version (una clase heredada) personalizada del controlador de Objection para cada tipo de modelo DESDE DONDE se le llama
      @objection.save
    end

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
