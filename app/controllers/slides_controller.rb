class SlidesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_slide, only: [:show, :edit, :update, :destroy]

  # GET /slides
  # GET /slides.json
  def index
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @slides = Slide.where(created_at: date_range).select(:id, :inform_id, :user_id, :created_at, :description, :slide_tag, :colored, :tagged, :covered, :stored).group(:id, :inform_id)
    else
      @slides = Slide.all.select(:id, :inform_id, :user_id, :created_at, :description, :slide_tag, :colored, :tagged, :covered, :stored).group(:id, :inform_id)
    end
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
    @inform = @slide.inform
    if @slide.slide_tag[-1] != "*"

      @blocks = @inform.blocks.where(slide_tag: @slide.slide_tag)  #Saco una coleccion de blocks asociadas al slide que voy a borrar

      @block = @blocks.first #Es para pasarla al render en JS

      @samples = @inform.samples.where(slide_tag: @slide.slide_tag, name: "Extendido")  #Saco una coleccion de samples asociadas al slide que voy a borrar
      @sample = @samples.first #Es para pasarla al render en JS
      # @recipient = Recipient.where(inform_id: @sample.inform_id, tag: @sample.recipient_tag).first  #Es para pasarla al render en JS
      @recipient = nil

      

    
      @samples.each do |sample|
        sample.update(slide_tag: nil) #Borro todas las asociaciones encontradas en las tags de samples
      end

      @blocks.each do |block|
        block.update(slide_tag: nil) #Borro todas las asociaciones encontradas en las tags de samples
      end

    end
    @samplesc = @inform.samples.where(name: "Cassette")  #Saco una coleccion de samples asociadas al slide que voy a borrar
    @blocks = @inform.blocks  #Recargo todos los block para renderizado
    @slide.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @slide = Slide.find(params[:id])
      @inf = @slide.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slide_params
      params.require(:slide).permit(:inform_id, :user_id, :slide_tag, :stored, :description, :colored, :tagged, :covered)
    end
end
