class WelcomeController < ApplicationController
  def index
    @books = Book.all.order("updated_at DESC").limit(30)
  end
end
