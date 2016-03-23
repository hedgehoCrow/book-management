class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:asin]
      @book = Book.find_or_initialize_by(asin: params[:asin])
    else
      @book = Book.find(params[:book_id])
    end

    # booksテーブルに存在しない場合はAmazonのデータを登録する。
    if @book.new_record?
      begin
        # TODO 商品情報の取得 Amazon::Ecs.item_lookupを用いてください
        response = Amazon::Ecs.item_lookup(params[:asin], 
                                            :response_group => 'Medium',
                                            :country => 'jp')
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      amazon_book       = response.items.first
      @book.title        = amazon_book.get('ItemAttributes/Title')
      @book.small_image  = amazon_book.get("SmallImage/URL")
      @book.medium_image = amazon_book.get("MediumImage/URL")
      @book.large_image  = amazon_book.get("LargeImage/URL")
      @book.detail_page_url = amazon_book.get("DetailPageURL")
      @book.raw_info        = amazon_book.get_hash
      @book.save!
    end

    # TODO ユーザにwant or haveを設定する
    # params[:type]の値にHaveボタンが押された時には「Have」,
    # Wantボタンが押された時には「Want」が設定されています。
    if params[:type] == "Have"
      current_user.have(@book)
    else
      current_user.want(@book)
    end
  end

  def destroy
    @book = Book.find(params[:book_id])

    # TODO 紐付けの解除。 
    # params[:type]の値にHave itボタンが押された時には「Have」,
    # Want itボタンが押された時には「Want」が設定されています。
    if params[:type] == "Have"
      current_user.unhave(@book)
    else
      current_user.unwant(@book)
    end
  end
end
