class Grave < ApplicationRecord
    
    # 中間テーブル(grave_genres)を介して、多数のGenreを持つ
    has_many :grave_genres, dependent: :destroy
    has_many :genres, through: :grave_genres
    has_many :comments, dependent: :destroy
    has_many :posts, dependent: :destroy
    
    # 「Graveは、Postを通じて（through）、たくさんのCommentを持つ」という関係を定義
    has_many :comments, through: :posts 
 

end
