class Post < ApplicationRecord
  belongs_to :user
  belongs_to :grave

  validates :title, presence: true
  validates :body, presence: true
  validates :status, presence: true, inclusion: { in: } # 0:公開, 1:非公開, 2:審査中

end
