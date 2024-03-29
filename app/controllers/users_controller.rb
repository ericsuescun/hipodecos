class UsersController < ApplicationController
  before_action :authenticate_admin!
  # before_action :authenticate_user!, only: [:sign_in]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @tab = :admins
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # # GET /users/new
  # def new
  #   @user = User.new
  # end

  # GET /users/1/edit
  def edit
  end

  # # POST /users
  # # POST /users.json
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /users/1
  # # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      if params[:user][:remove_cvfile] == '1'
        @user.remove_cvfile!
      end
      if params[:user][:remove_signfile] == '1'
        @user.remove_signfile!
      end
      if params[:user][:remove_contract] == '1'
        @user.remove_contract!
      end
      @user.save
      redirect_to user_path(@user), notice: 'User fue exitosamente actualizado.'
    else
      render :edit
    end
  end

  # # DELETE /users/1
  # # DELETE /users/1.json
  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email2, :tel, :cel, :birth_date, :join_date, :active, :deactivation_date, :last_admin_id, :notes, :role_id, :file_id, :address, :cvfile, :signfile, :contract, :register,  :emergency_contact, :emergency_tel, :emergency_cel)
    end
end
