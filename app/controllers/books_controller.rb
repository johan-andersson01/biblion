class BooksController < ApplicationController
  before_action :logged_in_user, only: [:new]
  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def all_by_author
    @books = Book.where("author =  ?", params[:author]).paginate(page: params[:page])
    @author = params[:author]
  end

  def all_by_location
    @books = Book.where("location =  ?", params[:location]).paginate(page: params[:page])
    @location = params[:location]
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Vänligen logga in."
        redirect_to login_url
      end
    end
end
