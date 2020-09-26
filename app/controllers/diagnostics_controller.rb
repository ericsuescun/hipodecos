class DiagnosticsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diagnostic, only: [:show, :edit, :update, :destroy]

  # GET /diagnostics
  # GET /diagnostics.json
  def index
    @diagnostics = Diagnostic.all
  end

  # GET /diagnostics/1
  # GET /diagnostics/1.json
  def show
  end

  # GET /diagnostics/new
  def new
    @inform = Inform.find(params[:inform_id])
    get_diagcodes
  end

  # GET /diagnostics/1/edit
  def edit
    @inform = @diagnostic.inform
    get_diagcodes
  end

  # POST /diagnostics
  # POST /diagnostics.json
  def create
    @inform = Inform.find(params[:inform_id])
    @diagnostic = @inform.diagnostics.build(diagnostic_params)
    @diagnostic.user_id = current_user.id

    @diagnostic.who_code = Diagcode.where(pss_code: @diagnostic.pss_code).first.who_code

    @diagnostic.save

    get_diagcodes
  end

  def update
    @diagnostic.update(diagnostic_params)

    @inform = @diagnostic.inform
    get_diagcodes
  end

  def update_old
    if params[:diagnostic][:edit_dx_status] == "true"
      log = ""
      if @diagnostic.description != diagnostic_params[:description]
        log += "FECHA: " + Date.today.to_s
        log += " CAMBIOS: "
        log += " Descripción - ANTES: " + @diagnostic.description
        log += ", por: " + User.where(id: @diagnostic.user_id).first.try(:email).to_s
        log += " Descripción - DESPUES: " + diagnostic_params[:description].to_s
        log += ", por: " + current_user.email + " \n"

      else
        log += "FECHA: " + Date.today.to_s
        log += " DECRIPCIÓN SIN CAMBIOS."
      end

      if @diagnostic.pss_code != diagnostic_params[:pss_code]
        log += "FECHA: " + Date.today.to_s
        log += " CAMBIOS: "
        log += " Descripción - ANTES: " + @diagnostic.pss_code
        log += ", por: " + User.where(id: @diagnostic.user_id).first.try(:email).to_s
        log += " Descripción - DESPUES: " + diagnostic_params[:pss_code].to_s
        log += ", por: " + current_user.email + " \n"

      else
        log += "FECHA: " + Date.today.to_s
        log += " CÓDIGO PSS SIN CAMBIOS."
      end

      if @diagnostic.result != diagnostic_params[:result]
        log += "FECHA: " + Date.today.to_s
        log += " CAMBIOS: "
        log += " Descripción - ANTES: " + @diagnostic.result
        log += ", por: " + User.where(id: @diagnostic.user_id).first.try(:email).to_s
        log += " Descripción - DESPUES: " + diagnostic_params[:result].to_s
        log += ", por: " + current_user.email + " \n"

      else
        log += "FECHA: " + Date.today.to_s
        log += " CÓDIGO PSS SIN CAMBIOS."
      end

      if @diagnostic.inform.inf_type != "cito"
        # Se actualiza el who_code con lo que llegue por params de cambios en pss_code
        @diagnostic.who_code = Diagcode.where(pss_code: diagnostic_params[:pss_code]).first.who_code
      end

      #Obcode 16 corresponde a error en automatico o codigo biopsias
      @objection = @diagnostic.objections.new(
        responsible_user_id: @diagnostic.user_id,
        user_id: current_user.id,
        description: log,
        obcode_id: 16,
        close_user_id: nil,
        closed: false
      ) 
      #@objectionable se crea en una version (una clase heredada) personalizada del controlador de Objection para cada tipo de modelo DESDE DONDE se le llama
      @objection.save
    end

    @diagnostic.update(diagnostic_params)

    @inform = @diagnostic.inform
    get_diagcodes
  end

  def review
    @objection = Objection.find(params[:objection_id])
    @diagnostic = Diagnostic.find(params[:diagnostic_id])
    @inform = @diagnostic.inform

    get_diagcodes
  end

  def anotate
    @objection = Objection.find(params[:objection_id])
    @diagnostic = Diagnostic.find(params[:diagnostic_id])
    new_description = @objection.description.to_s + "FECHA: " + Date.today.to_s + " REVISIÓN: " + params[:new_description].to_s + ", por: " + current_user.email
    @objection.update(
      description: new_description,
      close_user_id: current_user.id,
      close_date: Date.today,
      closed: true
    )

    @inform = @diagnostic.inform
    get_diagcodes
  end

  
  def destroy
    @inform = @diagnostic.inform
    get_diagcodes

    @diagnostic.destroy
  end

  def destroy_diagnostic
    @diagnostic = Diagnostic.find(params[:diagnostic_id])
    @inform = @diagnostic.inform
    get_diagcodes

    @diagnostic.destroy
  end

  private
    def get_diagcodes
      @diagcodes = []
      # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
      Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
        if @inform.inf_type != 'cito'
          o_code = Organ.where(organ: sample.organ_code).first.organ_code.to_i
          Diagcode.where(organ_code: o_code).each do |diagcode|
            if diagcode.pss_code != nil
              # diagcode.description = diagcode.pss_code.to_s + " - " + diagcode.description.to_s 
              diagcode.description = diagcode.pss_code.to_s + " - " + diagcode.organ.to_s + " " + diagcode.feature1.to_s + " "  + diagcode.feature2.to_s + " "  + diagcode.feature3.to_s + " " + diagcode.feature4.to_s + " " + diagcode.feature5.to_s 
            else
              diagcode.description = " ---- " + diagcode.description.to_s + " ---- "
            end
            @diagcodes << diagcode
          end
        else
          Citocode.all.each do |citocode|
            citocode.description = citocode.result_type + " " + citocode.cito_code.to_s + ". " + citocode.description
            @diagcodes << citocode
          end
        end
        
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_diagnostic
      @diagnostic = Diagnostic.find(params[:id])
      @inf = @diagnostic.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diagnostic_params
      params.require(:diagnostic).permit(:inform_id, :user_id, :description, :diagcode_id, :pss_code, :who_code, :result)
    end
end
