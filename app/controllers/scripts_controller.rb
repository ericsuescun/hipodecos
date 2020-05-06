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
  end

  # GET /scripts/1/edit
  def edit
    @automatic = Automatic.find(@script.automatic.id)
    @selected = @automatic.organ
  end

  # POST /scripts
  # POST /scripts.json
  def create
    # @script = Script.new(script_params)
    @automatic = Automatic.find(params[:automatic_id])
    @script = @automatic.scripts.build(script_params)
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
      params.require(:script).permit(:automatic_id, :script_type, :description, :param1, :param2, :script_order, :organ)
    end
end
