class CytologiesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_cytology, only: [:show, :edit, :update, :destroy]

	def index
	  @cytologies = Cytology.all
	end

	# GET /cytologies/1
	# GET /cytologies/1.json
	def show
	end

	# GET /cytologies/new
	def new
	  @inform = Inform.find(params[:inform_id])
	end

	# GET /cytologies/1/edit
	def edit
	  @inform = @cytology.inform
	  @edit_cy_status = true
	end

	# POST /cytologies
	# POST /cytologies.json
	def create
	  @inform = Inform.find(params[:inform_id])
	  @cytology = @inform.cytologies.build(cytology_params)
	  @cytology.user_id = current_user.id
	  # @cytology.user_id = current_user.id
	  # @automatics = Automatic.where(auto_type: "micro")
	  @cytology.save

	  # get_automatics

	end

	# PATCH/PUT /cytologies/1
	# PATCH/PUT /cytologies/1.json
	def update
	  if params[:cytology][:edit_status] == "true"

	    log = "EMBARAZOS: "
	    if @cytology.pregnancies.to_s != cytology_params[:pregnancies]
	      log += "FECHA: " + Date.today.to_s
	      log += " Descripción - ANTES: " + @cytology.pregnancies.to_s
	      log += ", por: " + User.where(id: @cytology.user_id).first.try(:email).to_s
	      log += " Descripción - DESPUES: " + cytology_params[:pregnancies].to_s
	      log += ", por: " + current_user.email + " \n"

	    else
	      log += "FECHA: " + Date.today.to_s
	      log += " SIN CAMBIOS."
	    end

	    log += "FECHA ULTIMA MENSTRUACIÓN: "
	    if @cytology.last_mens != cytology_params[:last_mens]
	      log += "FECHA: " + Date.today.to_s
	      log += " Descripción - ANTES: " + @cytology.last_mens
	      log += ", por: " + User.where(id: @cytology.user_id).first.try(:email).to_s
	      log += " Descripción - DESPUES: " + cytology_params[:last_mens].to_s
	      log += ", por: " + current_user.email + " \n"

	    else
	      log += "FECHA: " + Date.today.to_s
	      log += " SIN CAMBIOS."
	    end

	    log += "CITA ANTERIOR: "
	    if @cytology.prev_appo != cytology_params[:prev_appo]
	      log += "FECHA: " + Date.today.to_s
	      log += " Descripción - ANTES: " + @cytology.prev_appo
	      log += ", por: " + User.where(id: @cytology.user_id).first.try(:email).to_s
	      log += " Descripción - DESPUES: " + cytology_params[:prev_appo].to_s
	      log += ", por: " + current_user.email + " \n"

	    else
	      log += "FECHA: " + Date.today.to_s
	      log += " SIN CAMBIOS."
	    end

	    log += "FECHA DE LA TOMA: "
	    if @cytology.sample_date.to_s != cytology_params[:sample_date]
	      log += "FECHA: " + Date.today.to_s
	      log += " Descripción - ANTES: " + @cytology.sample_date.to_s
	      log += ", por: " + User.where(id: @cytology.user_id).first.try(:email).to_s
	      log += " Descripción - DESPUES: " + cytology_params[:samle_date].to_s
	      log += ", por: " + current_user.email + " \n"

	    else
	      log += "FECHA: " + Date.today.to_s
	      log += " SIN CAMBIOS."
	    end

	    log += "ÚLTIMO RESULTADO: "
	    if @cytology.last_result != cytology_params[:last_result]
	      log += "FECHA: " + Date.today.to_s
	      log += " Descripción - ANTES: " + @cytology.last_result
	      log += ", por: " + User.where(id: @cytology.user_id).first.try(:email).to_s
	      log += " Descripción - DESPUES: " + cytology_params[:last_result].to_s
	      log += ", por: " + current_user.email + " \n"

	    else
	      log = "FECHA: " + Date.today.to_s
	      log += " SIN CAMBIOS."
	    end

	    log += "PLANIFICA: "
	    if @cytology.birth_control.to_s != cytology_params[:birth_control]
	      log += "FECHA: " + Date.today.to_s
	      log += " Descripción - ANTES: " + @cytology.birth_control.to_s
	      log += ", por: " + User.where(id: @cytology.user_id).first.try(:email).to_s
	      log += " Descripción - DESPUES: " + cytology_params[:birth_control].to_s
	      log += ", por: " + current_user.email + " \n"

	    else
	      log = "FECHA: " + Date.today.to_s
	      log += " SIN CAMBIOS."
	    end

	    #Obcode 19 corresponde a Descripción Macro o cytology mal redactada
	    @objection = @cytology.objections.new(
	      responsible_user_id: @cytology.user_id,
	      user_id: current_user.id,
	      description: log,
	      obcode_id: 19,
	      close_user_id: nil,
	      closed: false
	    ) 
	    
	    @objection.save
	  end
	  

	  @cytology.update(cytology_params)
	  

	  @inform = @cytology.inform
	  # get_automatics
	end

	def review
	  @objection = Objection.find(params[:objection_id])
	  @cytology = Cytology.find(params[:cytology_id])
	  @inform = @cytology.inform
	end

	def anotate
	  @objection = Objection.find(params[:objection_id])
	  @cytology = Cytology.find(params[:cytology_id])
	  new_description = @objection.description.to_s + " FECHA: " + Date.today.to_s + " REVISIÓN: " + params[:new_description].to_s + ", por: " + current_user.email
	  @objection.update(
	    description: new_description,
	    close_user_id: current_user.id,
	    close_date: Date.today,
	    closed: true
	  )

	  @inform = @cytology.inform
	end

	# def anotate
	#   @objection = Objection.find(params[:objection_id])
	#   @cytology = Cytology.find(params[:micro_id])
	#   new_description = @objection.description.to_s + "FECHA: " + Date.today.to_s + " REVISIÓN: " + params[:new_description].to_s + ", por: " + current_user.email
	#   @objection.update(
	#     description: new_description,
	#     close_user_id: current_user.id,
	#     close_date: Date.today,
	#     closed: true
	#   )

	#   @inform = @cytology.inform
	#   get_automatics
	# end

	# DELETE /cytologies/1
	# DELETE /cytologies/1.json
	def destroy
		@inform = @cytology.inform
		@automatics = Automatic.where(auto_type: "micro")
		@cytology.destroy
	end

	def destroy_cytology
	  @cytology = Cytology.find(params[:cytology_id])
	  @inform = @cytology.inform
	  # get_automatics

	  @cytology.destroy
	end

	private
	  # def get_automatics
	  #   @automatics = []
	  #   # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
	  #   Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
	  #     Automatic.where(auto_type: "cytology", organ: sample.organ_code).each do |auto|
	  #       @automatics << auto
	  #     end
	  #   end
	  # end
	  # Use callbacks to share common setup or constraints between actions.
	  def set_cytology
	    @cytology = Cytology.find(params[:id])
	    @inf = @cytology.inform_id
	  end

	  # Never trust parameters from the scary internet, only allow the white list through.
	  def cytology_params
	    params.require(:cytology).permit(:inform_id, :pregnancies, :last_mens, :prev_appo, :sample_date, :last_result, :birth_control, :user_id, :suggestion)
	  end
end
