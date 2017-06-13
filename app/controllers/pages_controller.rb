class PagesController < ApplicationController
  $name = "Biblion"
  def home
    @title = $name
  end

  def signup
    @title = $name
  end
end
