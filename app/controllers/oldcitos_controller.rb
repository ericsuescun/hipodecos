class OldcitosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_oldcito, only: [:show, :edit, :update, :destroy]

  def import
    Oldcito.import(params[:file])
    redirect_to oldcitos_path, notice: "Datos importados!"
  end

  # GET /oldrecords
  # GET /oldrecords.json
  def index
    # @oldrecords = Oldrecord.all

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
      @oldcitos = Oldcito.where(fecharec: date_range).paginate(page: params[:page], per_page: 60)
    else
      @oldcitos = Oldcito.where(fecharec: Date.parse("01/07/2020")..Date.parse("31/07/2020")).paginate(page: params[:page], per_page: 60)
    end
  end

  def trouble_index
    @oldcitos = Oldcito.where(diag: nil).paginate(page: params[:page], per_page: 60)
  end

  # GET /oldcitos/1
  # GET /oldcitos/1.json
  def show
  end

  # GET /oldcitos/new
  def new
    @oldcito = Oldcito.new
  end

  # GET /oldcitos/1/edit
  def edit
  end

  # POST /oldcitos
  # POST /oldcitos.json
  def create
    @oldcito = Oldcito.new(oldcito_params)

    respond_to do |format|
      if @oldcito.save
        format.html { redirect_to @oldcito, notice: 'Oldcito was successfully created.' }
        format.json { render :show, status: :created, location: @oldcito }
      else
        format.html { render :new }
        format.json { render json: @oldcito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oldcitos/1
  # PATCH/PUT /oldcitos/1.json
  def update
    respond_to do |format|
      if @oldcito.update(oldcito_params)
        format.html { redirect_to @oldcito, notice: 'Oldcito was successfully updated.' }
        format.json { render :show, status: :ok, location: @oldcito }
      else
        format.html { render :edit }
        format.json { render json: @oldcito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oldcitos/1
  # DELETE /oldcitos/1.json
  def destroy
    @oldcito.destroy
    respond_to do |format|
      format.html { redirect_to oldcitos_url, notice: 'Oldcito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oldcito
      @oldcito = Oldcito.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def oldcito_params
      params.require(:oldcito).permit(:clave, :numero, :fecharec, :fecha, :apellido, :apellido2, :nombre, :nombre2, :identif, :cedula, :historia, :uniedad, :edad, :sexo, :clinica, :entidad, :entad, :codval1, :por1, :saldo, :dnombre, :dapellido, :oficina, :telefono, :diag, :notas, :sugerencia, :citologa, :patologo, :celsup, :celint, :celpara, :plega, :agrupa, :prestador, :factura, :autoriz, :usuario, :ocupacion, :residencia, :zona, :emb, :estado, :embarazo, :fum, :citprev, :codigo, :codcito, :vinculado, :secretaria, :secretauno, :fecha1, :fechato, :resultado, :imprimir, :revisor, :fechanac, :sincroniza, :fsincro, :planifica, :muestra, :colade, :colinad, :montade, :montainad)
    end
end
