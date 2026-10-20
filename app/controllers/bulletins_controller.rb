class BulletinsController < ApplicationController
  before_action :authenticate_admin!

  # GET /bulletin
  def show
    @bulletin_url = BulletinUploader.current_url
  end

  # PATCH /bulletin
  def update
    if params[:image].blank?
      redirect_to bulletin_path, alert: "Selecciona una imagen para cargar."
      return
    end
    BulletinUploader.new.store!(params[:image])
    redirect_to bulletin_path, notice: "Boletín actualizado. Ya se muestra en Seguridad del paciente."
  rescue CarrierWave::UploadError => e
    redirect_to bulletin_path, alert: "No se pudo cargar: #{e.message}"
  end
end
