class RecipientsController < ApplicationController
  before_action :set_recipient, only: [:show, :edit, :update, :destroy]

  # GET /recipients
  # GET /recipients.json
  def index
    @recipients = Recipient.all
  end

  # GET /recipients/1
  # GET /recipients/1.json
  def show
  end

  # GET /recipients/new
  def new
    @recipient = Recipient.new
  end

  # GET /recipients/1/edit
  def edit
  end

  def create
    @inform = Inform.find(params[:inform_id])
    @recipient = @inform.recipients.build(recipient_params)
    @recipient.tag = @recipient.tag + '-R' + (@inform.recipients.count + 1).to_s
    @recipient.user_id = current_user.id
    # tag_shift = @inform.samples.count

    @recipient.save

    create_samples
      
    # if recipient.save
    #   redirect_to inform, notice: 'El recipiente fue creado exitosamente.'
    # else
    #   render :new
    # end
  end

  def update
    respond_to do |format|
      if @recipient.update(recipient_params)
        format.html { redirect_to @recipient, notice: 'Recipient was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient }
      else
        format.html { render :edit }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipient.destroy
    @inform = Inform.find(@inf)
    # redirect_to inform_path(@inf), notice: 'Recipient was successfully destroyed.'
  end

  private
    def create_samples
      if params[:recipient][:auto] != nil
        case params[:recipient][:auto]
        when "191"
          @recipient.update!(description: "MARCADO ANTRO: Se reciben  muestras de mucosa.  SE PROCESA TODO.")

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 1
          )

        when "192"
          @recipient.update!(description: "ESTOMAGO RESECCION
Estomago de () cms en la curvatura mayor y () cms en la curvatura menor, presenta una lesion (ulcerada) (vegetante) de () cms de diametro localizada en el (antro) (cuerpo) (fundus) con bordes (regulares) (irregulares). Esta ubicada a () cms del borde distal y compromete principalmente la curvatura (menor) (mayor) pero se extiende a (parte de) (toda) la circunferencia.
El resto de la mucosa est· preservada, sin otras lesiones.
Hay adherencias del epiplon en ambas curvaturas.  En la curvatura mayor se identifican () nÛdulos, el mayor de () cm de diametro.  Todos a menos de () cms de la serosa.  En la curvatura menor (no) (si) se identifican nÛdulos.
SE MARCAN BORDES DE RESECCION CON TINTA CHINA.
"
          )

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "SBPR:  BORDE DE RESECCION DISTAL Y TUMOR"
          )
          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "BORDE DE RESECCION PROXIMAL"
          )
          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "MUCOSA SANA"
          )
          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "LESION"
          )
          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 7,
            description: "NODULOS CURVATURA MAYOR"
          )
          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "GRASA CURVATURA MENOR"
          )

        when "193"
          @recipient.update!(description: "ESTOMAGO RESECCION
Se recibe cuerpo y antro-gastrico de ()x()x() cms, acompaÒado de delantal epiploico de () cms de longitud.  En el antro, en contacto con el borde de resecciÛn distal se encuentra una masa circular de ()x()x() cms que ulcera la mucosa e infiltra la pared subyacente, en todo su espesor, encontrandose en contacto con la serosa. La mucosa del resto de la pieza presenta un aspecto edematoso, con exageraciÛn de los pliegues, y apariencia de empedrado.  El borde de resecciÛn proximal se encuentra respetado.
SE MARCAN BORDES DE RESECCION CON TINTA CHINA.")
          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 4,
            description: "BORDE DE RESECCION ANTRAL"
          )

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "MASA"
          )

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 2,
            description: "BORDE DE RESECCION CORPORAL"
          )

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 1,
            description: "MUCOSA SIN TUMOR"
          )

        when "194"
          @recipient.update!(description: "ESOFAGO: Se reciben  muestras de mucosa.")

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Esofago",
            fragment: 1,
            description: "SE PROCESA TODO"
          )

          @recipient2 = @inform.recipients.build(recipient_params)
          @recipient2.tag = @inform.tag_code + '-R' + (@inform.recipients.count + 1).to_s
          @recipient2.user_id = current_user.id

          @recipient2.description = "ANTRO: Se reciben  muestras de mucosa."

          @recipient2.save

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient2.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Estomago",
            fragment: 1,
            description: "SE PROCESA TODO"
          )

          @recipient3 = @inform.recipients.build(recipient_params)
          @recipient3.tag = @inform.tag_code + '-R' + (@inform.recipients.count + 1).to_s
          @recipient3.user_id = current_user.id

          @recipient3.description = "DUODENO: Se reciben  muestras de mucosa."

          @recipient3.save

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient3.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Duodeno",
            fragment: 1,
            description: "SE PROCESA TODO"
          )

        when "221"
          @recipient.update!(description: "MARCADO APENDICE: Se recibe apendice de ()x()x() cm, serosa lisa con focos de despulimiento y congestion; al corte se aprecia pared edematosa y engrosada con luz ocupada por materias fecales liquidas. SE BLOQUEA PORCION REPRESENTATIVA.")

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Apendice",
            fragment: 1
          )

        when "222"
          @recipient.update!(description: "MARCADO APENDICE: Se recibe apendice de ()x()x() cm, serosa con despulimiento extenso y congestion severa y placas fibrinopurulentas superficiales; al corte se aprecia pared edematosa y engrosada con luz ocupada por materias fecales purulentas. SE BLOQUEA PORCION REPRESENTATIVA.")

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Apendice",
            fragment: 1
          )

        when "223"
          @recipient.update!(description: "MARCADO APENDICE: Se recibe apendice de ()x()x() cm, serosa opaca con despulimiento y congestion que presenta area sugestiva de necrosis; al corte se aprecia pared edematosa, hemorragica y engrosada con luz ocupada por materias fecales purulentas. SE BLOQUEA PORCION REPRESENTATIVA.")

          @inform.samples.create!(
            inform_id: params[:inform_id].to_i,
            user_id: current_user.id, 
            recipient_tag: @recipient.tag, 
            sample_tag: generate_letter_tag(@inform), 
            organ_code: "Apendice",
            fragment: 3
          )




        end
      else
        if params[:recipient][:samples].to_i > 20
          tag = generate_letter_tag(@inform) + '1'
          @inform.samples.create(inform_id: params[:inform_id].to_i, user_id: current_user.id, recipient_tag: @recipient.tag, sample_tag: tag)
          (22..params[:recipient][:samples].to_i).each do |i|
            
            @inform.samples.create(inform_id: params[:inform_id].to_i, user_id: current_user.id, recipient_tag: @recipient.tag, sample_tag: generate_number_tag(Sample.where(inform_id: params[:inform_id].to_i, sample_tag: tag).first))
            tag = generate_number_tag(Sample.where(inform_id: params[:inform_id].to_i, sample_tag: tag).first)
          end
        else
          if params[:recipient][:organ] != nil
            (1..params[:recipient][:samples].to_i).each do |i|
              @inform.samples.create!(inform_id: params[:inform_id].to_i, user_id: current_user.id, recipient_tag: @recipient.tag, sample_tag: generate_letter_tag(@inform), organ_code: params[:recipient][:organ])
            end
          else
            (1..params[:recipient][:samples].to_i).each do |i|
              @inform.samples.create(inform_id: params[:inform_id].to_i, user_id: current_user.id, recipient_tag: @recipient.tag, sample_tag: generate_letter_tag(@inform))
            end
          end
        end
      end
    end

    def generate_number_tag(sample)
      if sample.sample_tag[-1] =~ /[A-Z]/
        # sample.update(sample_tag: sample.sample_tag + '1')
        return sample.sample_tag + '2'
      end
      if sample.sample_tag[-1] =~ /[0-9]/
        return sample.sample_tag[0..-2] + (sample.sample_tag[-1].to_i + 1).to_s
      end
    end

    def generate_letter_tag(inform)
      next_letter = 'A'
      answer = false
      if inform.samples.empty?
        return inform.tag_code + '-A'
      end

      inform.samples.length.times {
        inform.samples.each do |sample|
          if (sample.sample_tag == inform.tag_code + '-' + next_letter) || (sample.sample_tag == inform.tag_code + '-' + next_letter + '1')
            next_letter = (next_letter.ord + 1).chr
            break
          end
        end
      }
      
      return inform.tag_code + '-' + next_letter
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_recipient
      @recipient = Recipient.find(params[:id])
      @inf = @recipient.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipient_params
      params.require(:recipient).permit(:inform_id, :user_id, :tag, :description, :samples)
    end
end
