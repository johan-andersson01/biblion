class BooksController < ApplicationController
  require 'will_paginate/array'

  before_action :load_book_or_redirect, only: %i[show edit]
  before_action :logged_in_user, only: [:create, :new, :edit, :add, :googlebooks_search]
  before_action :authorize_user, only: [:update, :destroy]

  def show; end

  def new
    @book = Book.new
  end

  def edit
    redirect_to root_path unless allowed_to_edit?
  end

  def update
    @book = Book.find_by("id = ?", params[:id])
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
       if @book.language == "sv"
          @book.language = "svenska"
       elsif @book.language == "en"
          @book.language = "engelska"
       elsif @book.language == "da"
          @book.language = "danska"
       elsif @book.language == "no"
          @book.language = "norska"
       elsif @book.language == "fi"
          @book.language = "finska"
       end
       @book.language.capitalize!
    end

    if current_user.disabled?
      flash[:danger] = "Du kan inte lägga upp böcker, eftersom ditt konto är avstängt"
      redirect_to root_url
    elsif !current_user.activated?
      flash[:danger] = "Du kan inte lägga upp böcker, eftersom du inte har aktiverat ditt konto"
      redirect_to root_url
    elsif @book.save
      flash[:success] = "Boken har lagts upp!"
      redirect_to @book
    else
      render 'new'
    end
  end

  def destroy
    @book = Book.find_by("id = ?", params[:id])
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
    @query = search_params[:query]
    @book = Book.new
    @books = []
    books = GoogleBooks.search(@query, {:count => 30})
    books.each do |book|
      tls_img = book.image_link(:zoom => 2)
      if !tls_img.nil? and !tls_img ["http:"].nil?
        tls_img ["http:"] = "https:"
      end

      @books.push(
        Book.new(
          author: book.authors,
          title: book.title,
          description: book.description,
          cover: tls_img,
          language: book.language,
          user: current_user,
          googlebooks: book.info_link,
          pages: book.page_count
        )
      )
    end
    
    render 'add'
  end

  def all_by_author
    @books = Book.where("author =  ? and donated = ?", params[:author], false)
    @count = @books.count
    @books = @books.paginate(page: params[:page])
    @author = params[:author]
  end

  def search_book
    if request.get?
      redirect_to root_url
    else
      @query = search_params[:query]
      @books = Set.new Book.search(@query).order("created_at DESC").to_a().select { |b| !b.donated }
      @users = User.search(@query).order("created_at DESC").to_a()
      @users.each do |u|
        u.books.each do |b|
          if !b.donated
            @books.add(b)
          end
        end
      end
      @books = @books.to_a()
      render 'search'
    end
  end

  def all_by_genre
    @books = Book.where("genre =  ? AND donated = ?", params[:genre], false)
    @count = @books.count
    @books = @books.paginate(page: params[:page])
    @genre = params[:genre]
  end

  def all_by_tag
    @books = Book.where("LOWER(tags) LIKE ? AND donated = ?", "%#{params[:tags]}%", false)
    @count = @books.count
    @books = @books.paginate(page: params[:page])
    @tag = params[:tags]
  end

  def all_by_location
    @users = User.where("location =  ?", params[:location])
    @books = []
    @users.each do |u|
      u.books.each do |b|
        if !b.donated
          @books |= [b]
        end
      end
    end
    @count = @books.count
    @books = @books.paginate(page: params[:page])
    @location = params[:location]
  end

  def all_by_landscape
    @users = User.where("landscape =  ?", params[:landscape])
    @books = []
    @users.each do |u|
      u.books.each do |b|
        if !b.donated
          @books.push(b)
        end
      end
    end
    @count = @books.count
    @books = @books.paginate(page: params[:page])
    @landscape = params[:landscape]
  end

  private

    def allowed_to_edit?
      @book.user == current_user || current_user.admin?
    end

    def load_book_or_redirect
      @book = Book.find_by id: params[:id]
      redirect_to root_url if @book.nil?
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Vänligen logga in."
        redirect_to login_url
      end
    end

    def authorize_user
        @book = Book.find_by("id = ?", params[:id])
        if @book.nil?
          redirect_to root_url
        else
          redirect_to(root_url) unless logged_in? && (@book.user == current_user || current_user.admin?)
        end
    end

    def book_params
      params.require(:book).permit(:title, :author, :year, :description, :comment, :cover, :language, :quality, :genre, :googlebooks, :pages, :tags, :donated)
    end

    def search_params
      params.require(:book).permit(:query)
    end
end
