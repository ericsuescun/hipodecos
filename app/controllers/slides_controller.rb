class SlidesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_slide, only: [:show, :edit, :update, :destroy]

  # GET /slides
  # GET /slides.json
  def index
    @slides = Slide.all
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
  end

  # GET /slides/new
  def new
    @slide = Slide.new
  end

  # GET /slides/1/edit
  def edit
  end

  # POST /slides
  # POST /slides.json
  def create
    inform = Inform.find(params[:inform_id])
    slide = inform.slides.build(slide_params)
    slide.user_id = current_user.id

    if slide.save
      slide.slide_tag = 'C' + Date.today.strftime('%y').to_s + '-' + inform.id.to_s
      slide.save
      redirect_to inform, notice: 'La placa ha sido creada exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /slides/1
  # PATCH/PUT /slides/1.json
  def update
    log = "\nCAMBIOS:\n"
    if @slide.slide_tag != slide_params[:slide_tag]
      log += "\n-ETIQUETA-\nANTES:" + @slide.slide_tag + "\n- DESPUÉS: -\n" + slide_params[:slide_tag]
    else
      log += "\n-ETIQUETA-\nSIN CAMBIOS."
    end
    if @slide.description != slide_params[:description]
      log += "\n-DESCRIPCION-\nANTES:" + @slide.description + "\n- DESPUÉS: -\n" + slide_params[:description]
    else
      log += "\n-DESCRIPCION-\nSIN CAMBIOS."
    end
    if @slide.stored != slide_params[:stored]
      log += "\n-GUARDADO-\nANTES:" + (@slide.stored == true ? 'Si' : 'No') + "\n- DESPUÉS: -\n" + (slide_params[:stored] == true ? 'Si' : 'No')
    else
      log += "\n-GUARDADO-\nSIN CAMBIOS."
    end
    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + slide_params[:slide_tag]

    if @slide.update(slide_params)
      @slide.objections.each do |objection|
        objection.closed = true
        objection.close_user_id = current_user.id
        objection.close_date = @slide.updated_at
        objection.description = objection.description + log
        objection.save
      end
      redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente actualizada.'
    else
      render :edit
    end
  end

  # DELETE /slides/1
  # DELETE /slides/1.json
  def destroy
    @slide.destroy
    respond_to do |format|
      format.html { redirect_to inform_path(@inf), notice: 'Slide was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @slide = Slide.find(params[:id])
      @inf = @slide.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slide_params
      params.require(:slide).permit(:inform_id, :user_id, :slide_tag, :stored, :description)
    end
end
