class ItemsController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_item, only: [:show]
  before_action :set_have_users, only: [:show]
  before_action :set_want_users, only: [:show]

  def new
    if params[:q]
      response = Amazon::Ecs.item_search(params[:q] , 
                                  :search_index => 'All' , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp')
      @amazon_items = response.items
    end
  end

  def show
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
  
  def set_have_users
    @have_users = @item.have_users;
  end
  
  def set_want_users
    @want_users = @item.want_users;
  end
end
