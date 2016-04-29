class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :authenticate_user, only:[:edit, :update]
  before_action :check_expiration, only:[:edit, :update]
  
  def new
  end

  def edit
    render 'edit' # does so by default
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user && @user.activated? && @user.activated?
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "Reactivation email send, please check email"
      redirect_to root_path
    else
      flash[:danger] = "Email not found, please re-enter"
      render 'new'
    end
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
        log_in @user
        flash[:success] = "Updated password"
        redirect_to @user
    else
        render 'edit'
    end
  end
  
  
  private
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def authenticate_user
      unless @user && @user.authenticated?(:reset, params[:id]) && @user.activated?
        flash[:danger] = "Invalid user"
        redirect_to root_path
      end
    end
    
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Reset expired, try again"
        redirect_to new_password_reset_path
      end
    end
  
  
end
