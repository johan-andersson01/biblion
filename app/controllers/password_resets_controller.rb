class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
    end
    flash[:success] = "Ett mail kommer att skickas med instruktioner för att återställa ditt lösenord."
    redirect_to login_url
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "Får inte vara tomt.")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      flash[:success] = "Ditt lösenord har uppdaterats."
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end

  def edit
  end

  private
  
      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end
  
      def get_user
        @user = User.find_by(email: params[:email])
      end
  
      def valid_user
        unless (@user && @user.activated? &&
                @user.authenticated?(:reset, params[:id]))
          redirect_to root_url
        end
      end
  
      def check_expiration
        if @user.password_reset_expired?
          flash[:danger] = "Password reset has expired."
          redirect_to new_password_reset_url
        end
      end
end
