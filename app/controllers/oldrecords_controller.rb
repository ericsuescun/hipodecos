class OldrecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_oldrecord, only: [:show, :edit, :update, :destroy]

  def import
    Oldrecord.import(params[:file])
    redirect_to oldrecords_path, notice: "Datos importados!"
  end

  # GET /oldrecords
  # GET /oldrecords.json
  def index
    @oldrecords = Oldrecord.all
  end

  # GET /oldrecords/1
  # GET /oldrecords/1.json
  def show
  end

  # GET /oldrecords/new
  def new
    @oldrecord = Oldrecord.new
  end

  # GET /oldrecords/1/edit
  def edit
  end

  # POST /oldrecords
  # POST /oldrecords.json
  def create
    @oldrecord = Oldrecord.new(oldrecord_params)

    respond_to do |format|
      if @oldrecord.save
        format.html { redirect_to @oldrecord, notice: 'Oldrecord was successfully created.' }
        format.json { render :show, status: :created, location: @oldrecord }
      else
        format.html { render :new }
        format.json { render json: @oldrecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oldrecords/1
  # PATCH/PUT /oldrecords/1.json
  def update
    respond_to do |format|
      if @oldrecord.update(oldrecord_params)
        format.html { redirect_to @oldrecord, notice: 'Oldrecord was successfully updated.' }
        format.json { render :show, status: :ok, location: @oldrecord }
      else
        format.html { render :edit }
        format.json { render json: @oldrecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oldrecords/1
  # DELETE /oldrecords/1.json
  def destroy
    @oldrecord.destroy
    respond_to do |format|
      format.html { redirect_to oldrecords_url, notice: 'Oldrecord was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oldrecord
      @oldrecord = Oldrecord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def oldrecord_params
      params.require(:oldrecord).permit(:clave, :numero, :fecharec, :fecha, :apellido, :apellido2, :nombre, :nombre2, :identif, :cedula, :historia, :uniedad, :edad, :sexo, :clinica, :entidad, :entad, :codval1, :por1, :codval2, :por2, :codval3, :por3, :saldo, :descr, :diagnostic, :codigo, :codigo1, :codigo2, :codigo3, :codigo4, :codigo5, :prestador, :factura, :autoriz, :usuario, :ocupacion, :residencia, :zona, :emb, :estado, :telefono, :dnombre, :dapellido, :oficina, :bloque, :patologo, :secretaria, :tipo, :imprimir, :secretauno, :fecha1, :firma, :rango, :dx, :revisor, :tiempo, :sincroniza, :fsincro)
    end
end
