class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_id, only: [:show,  :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.order("created_at ASC").page(params[:page]).per(Settings.perpage)
  end

  def show
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new user_params
  	if @user.save
      log_in @user
  	  flash[:success] = t "wellcome"
  	  redirect_to @user
  	else
  	  render :new
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.users.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "controller.users.delete"
    redirect_to users_url
  end

  private
  def user_params
  	params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def find_id
    @user = User.find_by id: params[:id]
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controller.users.please_login"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
