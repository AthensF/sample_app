class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :authenticate_user, only:[:edit, :update]
  
  def new
  end

  def edit
    
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user && @user.activated?
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
    
  end
  
  
  private
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    
    def authenticate_user
      unless @user && @user.authenticated?(:reset, params[:id])
        flash[:danger] = "Invalid user"
        redirect_to root_path
      end
    end
  
  
end
