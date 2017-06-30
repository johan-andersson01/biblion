class BooksController < ApplicationController
  require 'will_paginate/array'
  # require 'googlebooks'
  before_action :logged_in_user, only: [:new, :add, :googlebooks_search]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @auth = (current_user == @book.user || current_user.admin?)
    if @auth && @book.update_attributes(book_params)
      if current_user.admin
        flash[:success] = "Bok #{@book.id}:s information har nu uppdaterats"
        redirect_to @book
      else
      flash[:success] = "Bokens information har nu uppdaterats"
      redirect_to @book
      end
    elsif !@auth
      render 'root_url'
    else
      render 'edit'
    end
  end

  def create
    @book = current_user.books.build(book_params)
    @book.available = true
    @book.swaps = 0
    if @book.save
      flash[:success] = "Boken har lagts upp!"
      redirect_to @book
    else
      render 'new'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    if (current_user.admin?)
      @book.destroy
      flash[:success] = "Boken har raderats"
      redirect_to root_url
    elsif (current_user == @book.user)
      @book.destroy
      flash[:success] = "Din bok har nu tagits bort från Biblion"
      redirect_to root_url
    else
      render 'root_url'
    end
  end

  def add
    @book = Book.new
  end

  def googlebooks_search
    @query = googlebooks_params[:query]
    @book = Book.new
    @books = []
    books = GoogleBooks.search(@query, {:count => 12})
    first = books.first
    i = 0
#DateTime.strptime(book.published_date, '%Y-%m-%d %H:%M:%S %Z')
    books.each do |book|
      @books[i] = Book.new(
      author: book.authors,
      title: book.title,
      language: book.language,
      year: book.published_date,
      description: book.description,
      cover: book.image_link(:zoom => 6),
      user: current_user,
      googlebooks: book.info_link)
      i += 1
    end

    # while i < limit do
    #   @books[index] = Book.new(author: books[index].authors, title: books[index].title, year: books[index].published_date,
    #   description: books[index].description, cover: books[index].image_link(:zoom => 6), user: current_user)
    # end

    # @book = Book.new(author: first.authors, title: first.title, year: first.published_date,
    # description: first.description, cover: first.image_link(:zoom => 6), user: current_user)
    # puts @book.attributes
    render 'add'
  end

  def all_by_author
    @books = Book.where("author =  ?", params[:author]).paginate(page: params[:page])
    @author = params[:author]
  end

  def all_by_location
    # @books = Book.where("location =  ?", params[:location]).paginate(page: params[:page]))
    @users = User.where("location =  ?", params[:location])
    @books = []
    @users.each do |u|
      u.books.each do |b|
        @books.push(b)
      end
    end
    @books = @books.paginate(page: params[:page])
    @location = params[:location]
  end

  def all_by_landscape
    @users = User.where("landscape =  ?", params[:landscape])
    @books = []
    @users.each do |u|
      u.books.each do |b|
        @books.push(b)
      end
    end
    @books = @books.paginate(page: params[:page])
    @landscape = params[:landscape]
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Vänligen logga in."
        redirect_to login_url
      end
    end

    def authorize_user
        @book = Book.find(params[:id])
        redirect_to(root_url) unless logged_in? && (@book.user == current_user || current_user.admin)
    end

    def book_params
      params.require(:book).permit(:title, :author, :year, :description, :user_description, :cover, :language, :quality, :googlebooks)
    end

    def googlebooks_params
      params.require(:book).permit(:query)
    end
end
