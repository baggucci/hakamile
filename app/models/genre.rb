class Genre < ApplicationRecord
     # 中間テーブル(grave_genres)を介して、多数のGraveを持つ
  has_many :grave_genres, dependent: :destroy
  has_many :graves, through: :grave_genres

  validates :name, presence: true, uniqueness: true
end
