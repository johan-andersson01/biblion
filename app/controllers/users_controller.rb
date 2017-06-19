class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show]
  before_action :correct_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params_terms)
    if @user.save
      log_in @user
      flash[:success] = "Välkommen till Biblion, #{@user.name}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params_no_terms)
      flash[:success] = "Dina inställningar har nu uppdaterats"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params_terms
      params.require(:user).permit(:name, :email, :telephone,
       :password, :password_confirmation, :terms_of_service)
    end

    def user_params_no_terms
      params.require(:user).permit(:name, :email, :telephone,
       :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Vänligen logga in."
        redirect_to login_url
      end
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
    end
end
