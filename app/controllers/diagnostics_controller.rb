class DiagnosticsController < ApplicationController
  before_action :set_diagnostic, only: [:show, :edit, :update, :destroy]

  # GET /diagnostics
  # GET /diagnostics.json
  def index
    @diagnostics = Diagnostic.all
  end

  # GET /diagnostics/1
  # GET /diagnostics/1.json
  def show
  end

  # GET /diagnostics/new
  def new
    @diagnostic = Diagnostic.new
  end

  # GET /diagnostics/1/edit
  def edit
  end

  # POST /diagnostics
  # POST /diagnostics.json
  def create
    inform = Inform.find(params[:inform_id])
    diagnostic = inform.diagnostics.build(diagnostic_params)
    diagnostic.user_id = current_user.id

    if diagnostic.save
      redirect_to inform, notice: 'El diagnóstico ha sido creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /diagnostics/1
  # PATCH/PUT /diagnostics/1.json
  def update
    log = "\nCAMBIOS:\n"
    if @diagnostic.description != diagnostic_params[:description]
      log += "\n-DESCRIPCIÓN-\nANTES:" + @diagnostic.description + "\n- DESPUÉS: -\n" + diagnostic_params[:description]
    else
      log += "\n-DESCRIPCIÓN-\nSIN CAMBIOS."
    end

    log += "\nFECHA: " + Date.today.strftime('%d/%m/%Y') + "\nUSUARIO: " + current_user.email.to_s

    if @diagnostic.update(diagnostic_params)
      @diagnostic.objections.each do |objection|
        objection.closed = true
        objection.close_user_id = current_user.id
        objection.close_date = @diagnostic.updated_at
        objection.description = objection.description + log
        objection.save
      end
      redirect_to @diagnostic, notice: 'Diagnostic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /diagnostics/1
  # DELETE /diagnostics/1.json
  def destroy
    @diagnostic.destroy
      redirect_to diagnostics_url, notice: 'Diagnostic was successfully destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diagnostic
      @diagnostic = Diagnostic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diagnostic_params
      params.require(:diagnostic).permit(:inform_id, :user_id, :description)
    end
end
