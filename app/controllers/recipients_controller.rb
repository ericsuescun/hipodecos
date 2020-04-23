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
    inform = Inform.find(params[:inform_id])
    recipient = inform.recipients.build(recipient_params)
    recipient.tag = recipient.tag + '-R' + (inform.recipients.count + 1).to_s
    recipient.user_id = current_user.id
    tag_shift = inform.samples.count

    (1..params[:recipient][:samples].to_i).each do |i|
      inform.samples.create(inform_id: params[:inform_id].to_i, user_id: current_user.id, recipient_tag: recipient.tag, sample_tag: inform.tag_code + (65 + tag_shift + i - 1).chr)
    end
      
    if recipient.save
      redirect_to inform, notice: 'El recipiente fue creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /recipients/1
  # PATCH/PUT /recipients/1.json
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

  # DELETE /recipients/1
  # DELETE /recipients/1.json
  def destroy
    @recipient.destroy
    redirect_to inform_path(@inf), notice: 'Recipient was successfully destroyed.'
  end

  private
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
