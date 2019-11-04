class ObjectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_objection, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
  end

  def create
    objection = @objectionable.objections.new(objection_params) #@objectionable se crea en una version (una clase heredada) personalizada del controlador de Objection para cada tipo de modelo DESDE DONDE se le llama
    objection.responsible_user_id = @objectionable.user_id #Se carga como responsable al creador de la sample
    objection.user_id = current_user.id
    objection.closed = false
    if objection.save
      redirect_to @objectionable, notice: "No conformidad levantada!"
    else
      redirect_to @objectionable, notice: "No conformidad vacía!"
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  def show
  end

  private
    def set_objection
      @objection = Objection.find(params[:id])
    end

    def objection_params
      params.require(:objection).permit(:user_id, :name, :responsible_user_id, :close_user_id, :close_date, :description, :closed)
    end
end
