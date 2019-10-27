class EntitiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  # GET /entities
  # GET /entities.json
  def index
    @tab = :admins
    @entities = Entity.all
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
    @branches = @entity.branches
  end

  # GET /entities/new
  def new
    @entity = Entity.new
  end

  # GET /entities/1/edit
  def edit
  end

  # POST /entities
  # POST /entities.json
  def create
    @entity = Entity.new(entity_params)  
    @branch = Branch.new  
    respond_to do |format|
      if @entity.save

        @branch.entity = @entity
        @branch.name = @entity.name
        @branch.initials = @entity.initials
        @branch.code = @entity.code
        @branch.mgr_name = @entity.mgr_name
        @branch.mgr_email = @entity.mgr_email
        @branch.mgr_tel = @entity.mgr_tel
        @branch.mgr_cel = @entity.mgr_cel
        @branch.municipality = @entity.municipality
        @branch.department = @entity.department
        @branch.address = @entity.address
        @branch.entype = @entity.entype
        
        @branch.save

        format.html { redirect_to @entity, notice: 'IPS creada exitosamente. Hicimos por ti una sede principal con los mismos datos, revísala!' }
        format.json { render :show, status: :created, location: @entity }
      else
        format.html { render :new }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to entities_path, notice: 'IPS editada exitosamente.' }
        format.json { render :show, status: :ok, location: @entity }
      else
        format.html { render :edit }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.json
  def destroy
    @entity.destroy
    respond_to do |format|
      format.html { redirect_to entities_url, notice: 'Entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:name, :initials, :code, :mgr_name, :mgr_email, :mgr_tel, :mgr_cel, :municipality, :department, :address, :entype, :cost_id, :rate_id)
    end
end
