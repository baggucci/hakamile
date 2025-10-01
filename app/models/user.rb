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


  # フォロー機能関連
  # 自分がフォローしているユーザーとの関係 (Active Relationship)
  # foreign_key: "follower_id" で、自分がフォローする側であることを示す
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

  # 自分をフォローしているユーザーとの関係 (Passive Relationship)
  # foreign_key: "followed_id" で、自分がフォローされる側であることを示す
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy

  # 自分がフォローしているユーザーの一覧
  # through: :active_relationships で中間テーブルを指定し、source: :followed で取得したいカラムを指定
  has_many :following, through: :active_relationships, source: :followed

  # 自分をフォローしているユーザーの一覧
  has_many :followers, through: :passive_relationships, source: :follower

   # --- フォロー機能のヘルパーメソッド ---
  # 指定したユーザーをフォローする
  def follow(other_user)
    # 自分自身はフォローできないようにする
    following << other_user unless self == other_user
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # すでにフォローしているか確認する
  def following?(other_user)
    following.include?(other_user)
  end

end
