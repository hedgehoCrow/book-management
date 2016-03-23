class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :asin
      t.string :title
      t.string :description
      t.string :detail_page_url
      t.string :small_image
      t.string :medium_image
      t.string :large_image
      t.string :raw_info

      t.timestamps null: false

      t.index [:asin], unique: true
    end
  end
end
