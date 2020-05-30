class ScriptsController < ApplicationController
  before_action :set_script, only: [:show, :edit, :update, :destroy]

  # GET /scripts
  # GET /scripts.json
  def index
    @scripts = Script.all
  end

  # GET /scripts/1
  # GET /scripts/1.json
  def show
  end

  # GET /scripts/new
  def new
    @script = Script.new
    @automatic = Automatic.find(params[:automatic_id])
    @script.script_order = @automatic.scripts.count + 1
    @selected = @automatic.organ
    o_code = Organ.where(organ: @selected).first.organ_code.to_i
    @diagcodes = Diagcode.where(organ_code: o_code)
  end

  # GET /scripts/1/edit
  def edit
    @automatic = Automatic.find(@script.automatic.id)
    @selected = @automatic.organ
    o_code = Organ.where(organ: @selected).first.organ_code.to_i
    @diagcodes = Diagcode.where(organ_code: o_code)
  end

  # POST /scripts
  # POST /scripts.json
  def create
    # @script = Script.new(script_params)
    @automatic = Automatic.find(params[:automatic_id])
    @script = @automatic.scripts.build(script_params)
    @script.user_id = current_user.id
    @script.who_code = Diagcode.where(pss_code: @script.pss_code).first.who_code

    if @script.script_type == "rec"
      @script.organ = ""
    end

      if @script.save
        redirect_to automatic_path(@automatic), notice: 'Script creado exitosamente!'
      else
        render :new
      end
  end

  # PATCH/PUT /scripts/1
  # PATCH/PUT /scripts/1.json
  def update
    @script.user_id = current_user.id

    if @script.update(script_params)
      redirect_to automatic_path(@script.automatic), notice: 'Script editado exitosamente!'
    else
      render :edit
    end
  end

  # DELETE /scripts/1
  # DELETE /scripts/1.json
  def destroy
    @script.destroy
    redirect_to automatic_path(@script.automatic), notice: 'Script borrado exitosamente!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_script
      @script = Script.find(params[:id])
      # @automatic = Automatic.find(script_params[:template_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def script_params
      params.require(:script).permit(:automatic_id, :script_type, :description, :param1, :param2, :script_order, :organ, :diagnostic, :pss_code, :who_code)
    end
end
