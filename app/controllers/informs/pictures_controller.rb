class Informs::PicturesController < PicturesController
	before_action :set_imageable

	def create
	  picture = @imageable.pictures.new(picture_params)
	  picture.user_id = current_user.id
	  if picture.save
	    redirect_to inform_path(params[:inform_id]), notice: "Foto exitosamente cargada."
	  else
	    redirect_to @imageable, notice: "Revisa el tamaño de la foto."
	  end
	end

	private
		def set_imageable
			@imageable = Inform.find(params[:inform_id])
		end
		
		def picture_params
		  params.require(:picture).permit(:name, :description)
		end
end