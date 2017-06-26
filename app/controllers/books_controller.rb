class BooksController < ApplicationController
  def show
    @book = Book.find(params[:id])
  end

  def all_by_author
    @books = Book.where(author: params[:author]).paginate(page: params[:page])
    @author = params[:author]
  end

  def all_by_location
    @books = Book.where(location: params[:location]).paginate(page: params[:page])
    @location = params[:location]
  end
end
