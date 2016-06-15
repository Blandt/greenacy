require 'httparty'
require 'kitco'
class Admin::UsersController < Admin::BaseAdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if(@user.parent_id !=0 && @user.parent_id)
      @manager = User.find(@user.parent_id)
    end
  end

  def getManager
    @managers = User.where(is_active: '1',role_id: '4',company_id:params[:company]).order("first_name DESC")
    respond_to do |format|
      format.json  { render :json => @managers }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @roles = Role.new
    @companies = Company.new
    @managers = User.where(is_active: '1',role_id: '4').order("first_name DESC")
    @companies = Company.where(is_active: '1').order("name DESC")
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
      puts e
  end

  # GET /users/1/edit
  def edit
    @roles = Role.new
    @companies = Company.new
    if(@user.company_id!='' && @user.company_id)
      @managers = User.where(is_active: '1',role_id: '4',company_id: @user.company_id).order("first_name DESC")
    else
      @managers = User.where(is_active: '1',role_id: '4').order("first_name DESC")
    end
    @companies = Company.where(is_active: '1').order("name DESC")
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
      puts e
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.username = params[:user][:username]
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation =params[:user][:password_confirmation]
    @user.role_id =params[:user][:role_id]
    @user.company_id =params[:user][:company_id]
    @user.parent_id =params[:user][:parent_id]
    @user.assay_mat =params[:user][:assay_mat]
    @user.is_active =1
    #@user.date =created_at.strftime('%Y-%m-%d')
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password_hash, :password_salt, :username, :is_admin, :is_active, :date, :role_id, :company_id, :parent_id, :assay_mat, :contact_number)
    end
end
