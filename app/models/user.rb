class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :books ,through: :ownerships
  
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_books, through: :wants, source: :book

  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_books, through: :haves, source: :book

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end

  ## TODO 実装
  def have(book)
    haves.find_or_create_by(book_id: book.id)
  end

  def unhave(book)
    haves.find_by(book_id: book.id).destroy
  end

  def have?(book)
    have_books.include?(book)
  end

  def want(book)
    wants.find_or_create_by(book_id: book.id)
  end

  def unwant(book)
    wants.find_by(book_id: book.id).destroy
  end

  def want?(book)
    want_books.include?(book)
  end
end
