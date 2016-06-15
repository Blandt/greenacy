require 'httparty'
require 'kitco'
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :manage, :change, :changeupdate, :changeupdatepwd, :changepwd]
  before_filter :authenticate_user!, :except => [:index]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @pt = Kitco.platinum
    @pd = Kitco.palladium
    @rh = Kitco.rhodium
    @pt = JSON.parse(@pt)
    @pd = JSON.parse(@pd)
    rescue JSON::ParserError, TypeError => e
      puts e
  end

  def manage
      if(current_user.role_id==4)
        @users = User.where(is_active: '1',role_id: '1',parent_id:current_user.id).order("first_name DESC")
      else
        redirect_to action:'index', alert: 'Sorry you donot have permission to access.'
      end
  end

  def adduser
    @user = User.new
    @parent_user =User.find(current_user.id)
    @roles = Role.new
    @companies = Company.new
  end

  def submituser
    @user = User.new(user_params)
    @parent_user =User.find(current_user.id)
    @roles = Role.new
    @companies = Company.new
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
    respond_to do |format|
      if @user.save
        format.html { redirect_to '/users/manage', notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :adduser }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change
      if(current_user.role_id==4)
        @user = User.find(params[:id])
      else
        redirect_to action:'index', alert: 'Sorry you donot have permission to access.'
      end
  end

  def changeupdate
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to '/users/manage', notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :change }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def changepwd
    if(current_user.role_id==4)
      @user = User.find(params[:id])
    else
      redirect_to action:'index', alert: 'Sorry you donot have permission to access.'
    end
  end

  def changeupdatepwd
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to '/users/manage', notice: 'Password was changed successfully.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :changepwd }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def userdelete
    @users = User.find(params[:id])
    respond_to do |format|
      if(@users.parent_id==current_user.id)
        @users.destroy
        format.html { redirect_to '/users/manage', notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to '/users/manage', notice: 'Sorry you do not have permission to delete the user.' }
        format.json { head :no_content }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to users_index_url
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
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
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if(params[:id])
        @user = User.find(params[:id])
      else
        @user = User.find(current_user.id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation, :username, :date, :assay_mat, :role_id, :company_id, :parent_id)
    end

end
