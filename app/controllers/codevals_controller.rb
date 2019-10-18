class CodevalsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_codeval, only: [:show, :edit, :update, :destroy]

  # GET /codevals
  # GET /codevals.json
  def index
    @codevals = Codeval.all
  end

  # GET /codevals/1
  # GET /codevals/1.json
  def show
  end

  # GET /codevals/new
  def new
    @codeval = Codeval.new
  end

  # GET /codevals/1/edit
  def edit
  end

  # POST /codevals
  # POST /codevals.json
  def create
    @codeval = Codeval.new(codeval_params)
    @codeval.admin_id = current_admin.id

    respond_to do |format|
      if @codeval.save
        format.html { redirect_to @codeval, notice: 'Codeval was successfully created.' }
        format.json { render :show, status: :created, location: @codeval }
      else
        format.html { render :new }
        format.json { render json: @codeval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /codevals/1
  # PATCH/PUT /codevals/1.json
  def update
    respond_to do |format|
      if @codeval.update(codeval_params)
        format.html { redirect_to @codeval, notice: 'Codeval was successfully updated.' }
        format.json { render :show, status: :ok, location: @codeval }
      else
        format.html { render :edit }
        format.json { render json: @codeval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /codevals/1
  # DELETE /codevals/1.json
  def destroy
    @codeval.destroy
    respond_to do |format|
      format.html { redirect_to codevals_url, notice: 'Codeval was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_codeval
      @codeval = Codeval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def codeval_params
      params.require(:codeval).permit(:name, :code, :description, :origin_system, :oms_code, :admin_id)
    end
end
