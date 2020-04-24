class SamplesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sample, only: [:show, :edit, :update, :destroy]

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
  end

  # POST /samples
  # POST /samples.json
  def create
    inform = Inform.find(params[:inform_id])
    tag_shift = inform.samples.count
    sample = inform.samples.build(sample_params)
    if sample.sample_tag[-1] == '2'
      fix_sample = Sample.where(inform_id: params[:inform_id], sample_tag: sample.sample_tag[0..-2]).first
      if fix_sample
        fix_sample.update(sample_tag: sample.sample_tag[0..-2] + '1')
      end
    end
    sample.user_id = current_user.id


    if sample.save
      redirect_to inform, notice: 'La muestra ha sido exitosamente creada.'
    else
      render :new
    end
  end

  # PATCH/PUT /samples/1
  # PATCH/PUT /samples/1.json
  def update
    # log = "\nCAMBIOS:\n-TITULO-\nANTES:" + @sample.name + "\n- DESPUÉS: -\n" + sample_params[:name] + ".\n-DESCRIPCIÓN-\nANTES:" + @sample.description + "\n- DESPUÉS: -\n" + sample_params[:description] + "-\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + sample_params[:sample_tag]
    log = "\nCAMBIOS:\n"
    if @sample.name != sample_params[:name]
      log += "\n-TITULO-\nANTES:" + @sample.name + "\n- DESPUÉS: -\n" + sample_params[:name]
    else
      log += "\n-TITULO-\nSIN CAMBIOS."
    end
    if @sample.description != sample_params[:description]
      log += "\n-DESCRIPCIÓN-\nANTES:" + @sample.description + "\n- DESPUÉS: -\n" + sample_params[:description]
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

    # if @sample.update(sample_params)
    #   @sample.objections.each do |objection|
    #     objection.closed = true
    #     objection.close_user_id = current_user.id
    #     objection.close_date = @sample.updated_at
    #     objection.description = objection.description + log
    #     objection.save
    #   end
    #   redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente actualizada.'
    # else
    #   render :edit
    # end
  end

  # DELETE /samples/1
  # DELETE /samples/1.json
  def destroy
    recipient = @sample.recipient_tag
    @sample.destroy
    samples_in_recipient = Sample.where(recipient_tag: recipient)
    if samples_in_recipient.length == 1
      if samples_in_recipient.first.sample_tag[-1] =~ /[0-9]/
        samples_in_recipient.first.update(sample_tag: samples_in_recipient.first.sample_tag[0..-2])
      end
    end
    redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente borrada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
      @inf = @sample.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sample_params
      params.require(:sample).permit(:inform_id, :user_id, :name, :description, :sample_tag, :recipient_tag, :organ_code)
    end
end
