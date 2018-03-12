class PagesController < ApplicationController
  def home
    @books = Book.where("donated = ?", false).paginate(page: params[:page])
  end

  def donated
    @donated = Book.where("donated = ?", true).paginate(page: params[:page])
  end




end
