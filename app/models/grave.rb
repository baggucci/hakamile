class Grave < ApplicationRecord
    
    # 中間テーブル(grave_genres)を介して、多数のGenreを持つ
    has_many :grave_genres, dependent: :destroy
    has_many :genres, through: :grave_genres
    has_many :comments, dependent: :destroy
    has_many :posts, dependent: :destroy
    
    # 「Graveは、Postを通じて（through）、たくさんのCommentを持つ」という関係を定義
    has_many :comments, through: :posts 

    # :latitude, :longitude カラムを位置情報として認識させる
    reverse_geocoded_by :latitude, :longitude
    
    # main_imageという名前で画像を1つ添付できるようにする
    has_one_attached :main_image

    acts_as_mappable default_units: :kms,
    lat_column_name: :latitude,
    lng_column_name: :longitude
end
