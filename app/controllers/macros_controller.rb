class MacrosController < ApplicationController
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
    respond_to do |format|
      if @macro.update(macro_params)
        format.html { redirect_to @macro, notice: 'Macro was successfully updated.' }
        format.json { render :show, status: :ok, location: @macro }
      else
        format.html { render :edit }
        format.json { render json: @macro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /macros/1
  # DELETE /macros/1.json
  def destroy
    @macro.destroy
    respond_to do |format|
      format.html { redirect_to macros_url, notice: 'Macro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_macro
      @macro = Macro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def macro_params
      params.require(:macro).permit(:inform_id, :user_id, :description)
    end
end
