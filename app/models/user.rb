class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :name, presence: true # 名前のバリデーションを追加

  has_many :posts, dependent: :destroy # この行を追加
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post # ユーザーがいいねした投稿

  # 投稿がいいね済みか確認するメソッド
  def liked?(post)
    self.liked_posts.include?(post)
  end
  
  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    User.find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.name = "guestuser"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  # ユーザー判別
  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  def self.ransackable_attributes(auth_object = nil)
    # ユーザー名などで検索できるようにする
    ["name"] 
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
