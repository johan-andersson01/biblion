class PagesController < ApplicationController
  def home
    @books = Book.all.paginate(page: params[:page])
  end

  def termsofservice
  end




end
