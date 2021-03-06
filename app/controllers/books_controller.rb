class BooksController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_book, only: [:show]
  before_action :set_have_users, only: [:show]
  before_action :set_want_users, only: [:show]

  def new
    if params[:q]
      response = Amazon::Ecs.item_search(params[:q] , 
                                  :search_index => 'All' , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp')
      @amazon_books = response.items
    end
  end

  def show
  end
  
  def show_stock
  end
  
  def show_reserved
  end
  
  def show_all
    @books = Book.all.order("updated_at DESC")
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end
  
  def set_have_users
    @have_users = @book.have_users;
  end
  
  def set_want_users
    @want_users = @book.want_users;
  end
end
