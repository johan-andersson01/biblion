class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Välkommen till Biblion, #{@user.name}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit

  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :telephone,
       :password, :password_confirmation, :terms_of_service) # add :terms_of_service if needed
    end
end
