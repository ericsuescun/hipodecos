class PicturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_picture, only: [:destroy]
  
  def index
  end

  def new
  end

  def create
    picture = @imageable.pictures.new(picture_params)
    picture.user_id = current_user.id
    if picture.save
      redirect_to inform_path(picture.imageable.inform_id), notice: "Foto exitosamente cargada."
    else
      redirect_to @imageable, notice: "Revisa el tamaño de la foto."
    end
  end

  def edit
  end

  def update
  end

  def destroy
    inf = @picture.imageable.inform_id  #Antes de borrar, cargo el id del inform de donde venía.
    # inf = params[:inform_id]
    @picture.destroy
    redirect_to inform_path(inf), notice: "La foto fue eliminada con éxito"
  end

  def show
  end

  private

    def set_picture
      @picture = Picture.find(params[:id])
    end

    def picture_params
      params.require(:picture).permit(:name, :description)
    end
end
