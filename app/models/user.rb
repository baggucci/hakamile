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
  
end
