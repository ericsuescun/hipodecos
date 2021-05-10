class SamplesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample, only: [:show, :edit, :edit_organ, :update_organ, :update, :destroy]

  # GET /samples
  # GET /samples.json
  def index
    @samples = Sample.all
  end

  # GET /samples/1
  # GET /samples/1.json
  def show
  end

  # GET /samples/new
  def new
    @sample = Sample.new
  end

  # GET /samples/1/edit
  def edit
    @inform = Inform.find(@sample.inform_id)
    recipient = @sample.recipient_tag
    @recipient = Recipient.where(tag: recipient).first
    @edit_sample_tag = @sample.sample_tag
    @automatics = Automatic.all
    @organs = Organ.all
  end

  def edit_organ
    @inform = Inform.find(@sample.inform_id)
    @organs = Organ.all.order(organ: :asc)
  end

  # POST /samples
  # POST /samples.json
  def create
    @inform = Inform.find(params[:inform_id])
    tag_shift = @inform.samples.count
    @sample = @inform.samples.build(sample_params)
    if @sample.sample_tag[-1] == '2'
      fix_sample = Sample.where(inform_id: params[:inform_id], sample_tag: @sample.sample_tag[0..-2]).first
      if fix_sample
        fix_sample.update(sample_tag: @sample.sample_tag[0..-2] + '1')
      end
    end
    @sample.user_id = current_user.id
    if params[:sample][:name] == "Extendido"
      @sample.fragment = 1  #Almaceno un dato en este campo por compatibilidad con la vista en la edición: que permita editar y que al hacerlo, pueda cerrar la edición. Sin fragmento no deja cerrar la edición
    end

    @sample.save

    recipient = @sample.recipient_tag
    @recipient = Recipient.where(tag: recipient).first
    @automatics = Automatic.all

  end

  def update
    # log = "\nCAMBIOS:\n-TITULO-\nANTES:" + @sample.name + "\n- DESPUÉS: -\n" + sample_params[:name] + ".\n-DESCRIPCIÓN-\nANTES:" + @sample.description + "\n- DESPUÉS: -\n" + sample_params[:description] + "-\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + sample_params[:sample_tag]
    log = "\nCAMBIOS:\n"
    if @sample.name != sample_params[:name]
      log += "\n-TITULO-\nANTES:" + @sample.name.to_s + "\n- DESPUÉS: -\n" + sample_params[:name].to_s
    else
      log += "\n-TITULO-\nSIN CAMBIOS."
    end
    if @sample.description != sample_params[:description]
      log += "\n-DESCRIPCIÓN-\nANTES:" + @sample.description.to_s + "\n- DESPUÉS: -\n" + sample_params[:description].to_s
    else
      log += "\n-DESCRIPCIÓN-\nSIN CAMBIOS."
    end
    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + sample_params[:sample_tag].to_s


    @sample.update(sample_params)
    @sample.objections.each do |objection|
      objection.closed = true
      objection.close_user_id = current_user.id
      objection.close_date = @sample.updated_at
      objection.description = objection.description + log
      objection.save
    end

    @inform = Inform.find(@sample.inform_id)
    recipient = @sample.recipient_tag
    @recipient = Recipient.where(tag: recipient).first
    @automatics = Automatic.all

  end

  def update_organ
    # log = "\nCAMBIOS:\n-TITULO-\nANTES:" + @sample.name + "\n- DESPUÉS: -\n" + sample_params[:name] + ".\n-DESCRIPCIÓN-\nANTES:" + @sample.description + "\n- DESPUÉS: -\n" + sample_params[:description] + "-\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + sample_params[:sample_tag]
    log = "\nCAMBIOS:\n"
    if @sample.organ_code != sample_params[:organ_code]
      log += "\n-ORGANO-\nANTES:" + @sample.organ_code.to_s + "\n- DESPUÉS: -\n" + sample_params[:organ_code].to_s
    else
      log += "\n-ORGANO-\nSIN CAMBIOS."
    end
    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + sample_params[:sample_tag].to_s
    @sample.update(sample_params)

    if @sample.name == "Cassette"
      block = Block.where(block_tag: @sample.sample_tag).first

      log = "\nCAMBIOS:\n"
      if block.organ_code != sample_params[:organ_code]
        log += "\n-ORGANO-\nANTES:" + block.organ_code.to_s + "\n- DESPUÉS: -\n" + sample_params[:organ_code].to_s
      else
        log += "\n-ORGANO-\nSIN CAMBIOS."
      end
      log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s
      block.update(organ_code: @sample.organ_code)

      objection = block.objections.build
      objection.closed = true
      objection.close_user_id = current_user.id
      objection.close_date = block.updated_at
      objection.description = objection.description.to_s + log
      objection.save
    end

    objection = @sample.objections.build
    objection.closed = true
    objection.close_user_id = current_user.id
    objection.close_date = @sample.updated_at
    objection.description = objection.description.to_s + log
    objection.save

    inform = Inform.find(@sample.inform_id)
    redirect_to inform_path(inform)
  end

  def destroy
    recipient = @sample.recipient_tag
    @recipient = Recipient.where(tag: recipient).first
    @sample.destroy
    samples_in_recipient = Sample.where(recipient_tag: recipient)

    if samples_in_recipient.length == 1
      if samples_in_recipient.first.sample_tag[-1] =~ /[0-9]/
        samples_in_recipient.first.update(sample_tag: samples_in_recipient.first.sample_tag[0..-2])
      end
    end
    @inform = Inform.find(@sample.inform_id)
    @automatics = Automatic.all

  end

  private
    def set_sample
      @sample = Sample.find(params[:id].to_i)
      @inf = @sample.inform_id
    end

    def sample_params
      params.require(:sample).permit(:inform_id, :user_id, :name, :description, :sample_tag, :recipient_tag, :organ_code, :fragment, :included, :blocked)
    end
end
