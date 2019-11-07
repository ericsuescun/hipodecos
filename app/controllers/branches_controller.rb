class BranchesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_branch, only: [:show, :edit, :update, :destroy]

  def import
    Branch.import(params[:file])
    redirect_to branches_path, notice: "Datos importados!"
  end

  # GET /branches
  # GET /branches.json
  def index
    @tab = :admins
    @branches = Branch.all
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
  end

  # GET /branches/new
  def new
    @branch = Branch.new
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches
  # POST /branches.json
  def create
    # @branch = Branch.new(branch_params)

    entity = Entity.find(params[:entity_id])

    respond_to do |format|
      if entity.branches.create(branch_params)
        format.html { redirect_to entity, notice: 'La sede ha sido creada exitosamente.' }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update
    ret_url = @branch.entity
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to ret_url, notice: 'La sede ha sido editada exitosamente.' }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    ret_url = @branch.entity
    @branch.destroy
    respond_to do |format|
      format.html { redirect_to ret_url, notice: 'La sede ha sido borrada exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def branch_params
      params.require(:branch).permit(:entity_id, :name, :initials, :code, :mgr_name, :mgr_email, :mgr_tel, :mgr_cel, :municipality, :department, :address, :entype)
    end
end
