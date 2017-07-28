class BooksController < ApplicationController
  require 'will_paginate/array'
  # require 'googlebooks'
  before_action :logged_in_user, only: [:new, :add, :googlebooks_search]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find_by(id: params[:id])
    @user = current_user
  end

  def new
      @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    unless @book.language.nil?
       @book.language.capitalize!
     end
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
    unless @book.language.nil?
       @book.language.capitalize!
     end
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
      description: book.description,
      cover: book.image_link(:zoom => 6),
      language: book.language,
      user: current_user,
      googlebooks: book.info_link,
      pages: book.page_count)
      i += 1
    end
    render 'add'
  end
"%#{name}%"
  def all_by_author
    @book = Book.new
    @books = Book.where("lower(author) like  ?", "%#{author_params[:author].downcase}%").paginate(page: params[:page])
    @author = author_params[:author].capitalize
    puts @author
    render 'all_by_author'
  end

  def all_by_genre
    @books = Book.where("genre =  ?", params[:genre]).paginate(page: params[:page])
    @genre = params[:genre]
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

  def request_book
    @book = Book.find_by(params[:id])
    @book.requesters = "#{@book.requesters}#{current_user.id.to_s} "
    puts @book.requesters
    redirect_to action: :show, id: params[:id]
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
      params.require(:book).permit(:title, :author, :year, :description, :user_description, :cover, :language, :quality, :genre, :googlebooks, :pages, :available)
    end

    def googlebooks_params
      params.require(:book).permit(:query)
    end

    def author_params
      params.require(:book).permit(:author)
    end
end
