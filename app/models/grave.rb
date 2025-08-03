class Grave < ApplicationRecord
 # 中間テーブル(grave_genres)を介して、多数のGenreを持つ
 has_many :grave_genres, dependent: :destroy
 has_many :genres, through: :grave_genres
 
 # ... 既存のコード ...

end
