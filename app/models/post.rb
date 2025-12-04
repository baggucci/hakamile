class Post < ApplicationRecord
  belongs_to :user
  belongs_to :grave
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many_attached :images

  validates :title, presence: true
  validates :body, presence: true

  enum status: { published: 0, unpublished: 1}

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # 一覧取得ロジックをモデルに移譲
  def self.visible_for(user, page)
    scope = includes(:user, :grave).order(created_at: :desc)
    scope = if user.present?
      scope.where("status = ? OR user_id = ?", statuses[:published], user.id)
    else
      scope.where(status: statuses[:published])
    end
    scope.page(page).per(5)
  end

  # ユーザーと属性から投稿を作成（バリデーション失敗は例外で伝搬）
  def self.create_for_user(user, attrs)
    post = user.posts.build(attrs)
    transaction do
      post.save!
    end
    post
  end

  # 画像削除を含む更新処理をモデル側で行う（delete_image_ids は配列または nil）
  def update_with_deleted_images(attrs, delete_image_ids)
    self.class.transaction do
      Array(delete_image_ids).each do |image_id|
        img = images.find_by(id: image_id)
        img.purge if img
      end
      update(attrs)
    end
  end

end
