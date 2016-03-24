class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_want_users, only: [:want_list]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "会員登録が完了しました"
    else
      render 'new'
    end
  end
  
  def show
    @books = @user.books.group('books.id')
  end
  
  def want_list
    @want_list = current_user.want_books;
  end
  
  def reserved_books
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  
  # TODO want_usersを用いる
  def set_want_users
    @want_users = [current_user];
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
