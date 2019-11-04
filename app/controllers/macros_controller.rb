class MacrosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_macro, only: [:show, :edit, :update, :destroy]

  # GET /macros
  # GET /macros.json
  def index
    @macros = Macro.all
  end

  # GET /macros/1
  # GET /macros/1.json
  def show
  end

  # GET /macros/new
  def new
    @macro = Macro.new
  end

  # GET /macros/1/edit
  def edit
  end

  # POST /macros
  # POST /macros.json
  def create
    inform = Inform.find(params[:inform_id])
    macro = inform.macros.build(macro_params)
    macro.user_id = current_user.id

    if macro.save
      redirect_to inform, notice: 'La macro ha sido creada exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /macros/1
  # PATCH/PUT /macros/1.json
  def update
    log = "\nCAMBIOS:\n"
    if @macro.description != macro_params[:description]
      log += "\n-DESCRIPCIÓN-\nANTES:" + @macro.description + "\n- DESPUÉS: -\n" + macro_params[:description]
    else
      log += "\n-DESCRIPCIÓN-\nSIN CAMBIOS."
    end

    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s

    if @macro.update(macro_params)
      @macro.objections.each do |objection|
        objection.closed = true
        objection.close_user_id = current_user.id
        objection.close_date = @macro.updated_at
        objection.description = objection.description + log
        objection.save
      end
      redirect_to @macro, notice: 'Diagnostic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /macros/1
  # DELETE /macros/1.json
  def destroy
    @macro.destroy
    respond_to do |format|
      format.html { redirect_to inform_path(@inf), notice: 'Macro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_macro
      @macro = Macro.find(params[:id])
      @inf = @macro.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def macro_params
      params.require(:macro).permit(:inform_id, :user_id, :description)
    end
end
