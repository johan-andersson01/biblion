class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show, :index, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]
  before_action :authorize_admin, only: [:index]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    user_params_terms[:location].capitalize!
    user_params_terms[:name].capitalize!
    @user = User.new(user_params_terms)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Kolla din mail för att aktivera ditt konto!"
      flash[:success] = "Välkommen till Biblion, #{@user.name}!"
      log_in @user
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
  end

  def update
    @user = User.find(params[:id])
    @auth = current_user.authenticate(user_params_new_password[:oldpassword])
    user_params_no_terms[:name].capitalize!
    user_params_no_terms[:location].capitalize!
    if @auth && @user.update_attributes(user_params_no_terms)
      if current_user.admin
        flash[:success] = "Användare #{@user.id}:s inställningar har nu uppdaterats"
        redirect_to users_url
      else
      flash[:success] = "Dina inställningar har nu uppdaterats"
      redirect_to @user
      end
    elsif !@auth
      flash[:danger] = "Fel lösenord"
      render 'edit'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if (current_user.admin? && current_user.authenticate(req_user_password[:password]))
      @user.destroy
      flash[:success] = "Användare raderad"
      redirect_to users_url
    elsif (@user.authenticate(req_user_password[:password]))
      @user.destroy
      session[:user_id] = nil
      flash[:success] = "Ditt konto har nu raderats"
      redirect_to root_url
    else
      flash[:danger] = "Fel lösenord"
      render 'edit'
    end
  end

  private

    def user_params_terms
      params.require(:user).permit(:name, :location, :landscape, :email,
       :password, :password_confirmation, :terms_of_service)
    end

    def user_params_new_password
      params.require(:user).permit(:name, :location, :landscape, :email, :oldpassword,
       :password, :password_confirmation)
    end

    def user_params_no_terms
      params.require(:user).permit(:name, :location, :landscape, :email,
       :password, :password_confirmation, :disabled)
    end

    def req_user_password
      params.require(:user).permit(:password)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Vänligen logga in."
        redirect_to login_url
      end
    end

    def authorize_user
        @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        redirect_to(root_url) unless current_user?(@user)||current_user.admin
    end

    def authorize_admin
      unless current_user.admin
        redirect_to root_url
      end

      #redirects to previous page
    end
end
