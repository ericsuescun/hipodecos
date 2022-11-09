class UtilityFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_utility_file, only: %i[ show edit update destroy download ]

  # GET /utility_files or /utility_files.json
  def index
    @utility_files = UtilityFile.all
    @utility_files.each do |file|
      file.description += '- *NO ENCONTRADO*' unless Pathname.new(file.filepath).exist?
    end
  end

  # GET /utility_files/1 or /utility_files/1.json
  def show
  end

  # GET /utility_files/new
  def new
    @utility_file = UtilityFile.new
  end

  def download
    file = File.read(@utility_file.filepath)
        
    send_data file[0..-4], filename: @utility_file.name, type: 'text/html; charset=utf-8'
  rescue => e
    redirect_to utility_files_url, notice: "Archivo no encontrado: #{@utility_file.name}"
  end
  

  # GET /utility_files/1/edit
  def edit
  end

  # POST /utility_files or /utility_files.json
  def create
    @utility_file = UtilityFile.new(utility_file_params)

    respond_to do |format|
      if @utility_file.save
        format.html { redirect_to @utility_file, notice: "Utility file was successfully created." }
        format.json { render :show, status: :created, location: @utility_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @utility_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /utility_files/1 or /utility_files/1.json
  def update
    respond_to do |format|
      if @utility_file.update(utility_file_params)
        format.html { redirect_to @utility_file, notice: "Utility file was successfully updated." }
        format.json { render :show, status: :ok, location: @utility_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @utility_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /utility_files/1 or /utility_files/1.json
  def destroy
    File.delete(@utility_file.filepath)

    @utility_file.destroy
    respond_to do |format|
      format.html { redirect_to utility_files_url, notice: "Utility file was successfully destroyed." }
      format.json { head :no_content }
    end
  rescue => e
    @utility_file.destroy
    redirect_to utility_files_url, notice: "Archivo no encontrado: #{@utility_file.name}. Eliminado de la lista de descarga"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_utility_file
      @utility_file = UtilityFile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def utility_file_params
      params.require(:utility_file).permit(:name, :filepath, :description)
    end
end
