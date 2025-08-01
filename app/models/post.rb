class Post < ApplicationRecord
  belongs_to :user
  belongs_to :grave
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
#  validates :status, presence: true, inclusion: { in: } # 0:公開, 1:非公開, 2:審査中

 # ===== Enums =====
  # ステータス (0:公開, 1:非公開, 2:審査中)
  enum status: { published: 0, unpublished: 1, pending: 2 }

  # ===== Methods =====
  # いいねされているかどうかを判定するメソッド
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end


end
