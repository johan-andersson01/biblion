class BooksController < ApplicationController
  require 'will_paginate/array'
  before_action :logged_in_user, only: [:new]

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

    def book_params
      params.require(:book).permit(:title, :author, :year, :description, :user_description, :cover)
    end
end
