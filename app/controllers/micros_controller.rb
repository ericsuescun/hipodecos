class MicrosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_micro, only: [:show, :edit, :update, :destroy]

  # GET /micros
  # GET /micros.json
  def index
    @micros = Micro.all
  end

  # GET /micros/1
  # GET /micros/1.json
  def show
  end

  # GET /micros/new
  def new
    @inform = Inform.find(params[:inform_id])
  end

  # GET /micros/1/edit
  def edit
    @inform = @micro.inform
    get_automatics
    @edit_status = true
  end

  # POST /micros
  # POST /micros.json
  def create
    @inform = Inform.find(params[:inform_id])
    @micro = @inform.micros.build(micro_params)
    @micro.user_id = current_user.id

    @micro.save

    get_automatics

  end

  # PATCH/PUT /micros/1
  # PATCH/PUT /micros/1.json
  def update
    if params[:micro][:edit_status] == "true"
      if @micro.description != micro_params[:description]
        log = "FECHA: " + Date.today.to_s
        log += " CAMBIOS: "
        log += " Descripción - ANTES: " + @micro.description
        log += ", por: " + User.where(id: @micro.user_id).first.try(:email).to_s
        log += " Descripción - DESPUES: " + micro_params[:description].to_s
        log += ", por: " + current_user.email + " \n"

      else
        log = "FECHA: " + Date.today.to_s
        log += " SIN CAMBIOS."
      end

      #Obcode 19 corresponde a Descripción Macro o Micro mal redactada
      @objection = @micro.objections.new(
        responsible_user_id: @micro.user_id,
        user_id: current_user.id,
        description: log,
        obcode_id: 19,
        close_user_id: nil,
        closed: false
      ) 
      #@objectionable se crea en una version (una clase heredada) personalizada del controlador de Objection para cada tipo de modelo DESDE DONDE se le llama
      @objection.save
    end
    

    @micro.update(micro_params)

    @inform = @micro.inform
    get_automatics
  end

  def review
    @objection = Objection.find(params[:objection_id])
    @micro = Micro.find(params[:micro_id])
    @inform = @micro.inform
    get_automatics

  end

  def anotate
    @objection = Objection.find(params[:objection_id])
    @micro = Micro.find(params[:micro_id])
    new_description = @objection.description.to_s + "FECHA: " + Date.today.to_s + " REVISIÓN: " + params[:new_description].to_s + ", por: " + current_user.email
    @objection.update(
      description: new_description,
      close_user_id: current_user.id,
      close_date: Date.today,
      closed: true
    )

    @inform = @micro.inform
    get_automatics
  end

  # DELETE /micros/1
  # DELETE /micros/1.json
  def destroy
    @micro.destroy
    respond_to do |format|
      format.html { redirect_to inform_path(@inf), notice: 'Micro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_micro
    @micro = Micro.find(params[:micro_id])
    @inform = @micro.inform
    get_automatics

    @micro.destroy
  end

  private
    def get_automatics
      @automatics = []
      @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
        Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
          @automatics << auto
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_micro
      @micro = Micro.find(params[:id])
      @inf = @micro.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def micro_params
      params.require(:micro).permit(:inform_id, :user_id, :description)
    end
end
