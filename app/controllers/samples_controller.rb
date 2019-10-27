class SamplesController < ApplicationController
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
    sample = inform.samples.build(sample_params)
    sample.user_id = current_user.id


    if sample.save
      sample.sample_tag = 'C' + Date.today.strftime('%y').to_s + '-' + inform.id.to_s
      sample.save
      redirect_to inform, notice: 'La muestra ha sido exitosamente creada.'
    else
      render :new
    end
  end

  # PATCH/PUT /samples/1
  # PATCH/PUT /samples/1.json
  def update
    if @sample.update(sample_params)
      redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente actualizada.'
    else
      render :edit
    end
  end

  # DELETE /samples/1
  # DELETE /samples/1.json
  def destroy
    @sample.destroy
    respond_to do |format|
      format.html { redirect_to inform_path(@inf), notice: 'La muestra ha sido exitosamente borrada.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
      @inf = @sample.inform_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sample_params
      params.require(:sample).permit(:inform_id, :user_id, :name, :description, :sample_tag)
    end
end
