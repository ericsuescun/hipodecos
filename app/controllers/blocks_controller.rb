class BlocksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_block, only: [:show, :edit, :update, :destroy]

  # GET /blocks
  # GET /blocks.json
  def index
    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @blocks = Block.where(created_at: date_range).group(:inform_id)
    else
      @blocks = Block.all.group(:inform_id)
    end

    if params[:yi]
      initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
      final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
      date_range = initial_date..final_date
      @samplesc = Sample.where(created_at: date_range, name: "Cassette")
    else
      @samplesc = Sample.where(name: "Cassette")
    end

  end

  # GET /blocks/1
  # GET /blocks/1.json
  def show
  end

  # GET /blocks/new
  def new
    @block = Block.new
  end

  # GET /blocks/1/edit
  def edit
  end

  # POST /blocks
  # POST /blocks.json
  def create
    inform = Inform.find(params[:inform_id])
    tag_shift = inform.blocks.count
    block = inform.blocks.build(block_params)
    block.user_id = current_user.id

    if block.save
      block.block_tag = inform.tag_code + (65 + tag_shift).chr
      block.save
      redirect_to inform, notice: 'El bloque ha sido creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /blocks/1
  # PATCH/PUT /blocks/1.json
  def update
    log = "\nCAMBIOS:\n"
    if @block.block_tag != block_params[:block_tag]
      log += "\n-ETIQUETA-\nANTES:" + @block.block_tag + "\n- DESPUÉS: -\n" + block_params[:block_tag]
    else
      log += "\n-ETIQUETA-\nSIN CAMBIOS."
    end
    if @block.description != block_params[:description]
      log += "\n-DESCRIPCION-\nANTES:" + @block.description + "\n- DESPUÉS: -\n" + block_params[:description]
    else
      log += "\n-DESCRIPCION-\nSIN CAMBIOS."
    end
    if @block.stored != block_params[:stored]
      log += "\n-GUARDADO-\nANTES:" + (@block.stored == true ? 'Si' : 'No') + "\n- DESPUÉS: -\n" + (block_params[:stored] == true ? 'Si' : 'No')
    else
      log += "\n-GUARDADO-\nSIN CAMBIOS."
    end
    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s + "\nEtiqueta: " + block_params[:block_tag]

    if @block.update(block_params)
      @block.objections.each do |objection|
        objection.closed = true
        objection.close_user_id = current_user.id
        objection.close_date = @block.updated_at
        objection.description = objection.description + log
        objection.save
      end
      redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente actualizada.'
    else
      render :edit
    end
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.json
  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to inform_path(@inf), notice: 'Block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(params[:id])
      @inf = @block.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_params
      params.require(:block).permit(:inform_id, :user_id, :block_tag, :stored, :description)
    end
end
