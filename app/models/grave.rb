class Grave < ApplicationRecord

    # Ransackが検索できるカラムのリストを定義します
    def self.ransackable_attributes(auth_object = nil)
        # ここに、ユーザーに検索を許可したいカラム名を文字列の配列として記述します
        # 今回エラーが出ている :name_or_prefecture に合わせて "name" と "prefecture" を含めます
        ["name", "prefecture", "description", "address"]
    end

    # (任意) Ransackが検索できる関連モデルのリストを定義します
    def self.ransackable_associations(auth_object = nil)
        # 例えばUserモデルやCommentモデルを関連検索したい場合に記述します
        [] # 今は空でOK
    end
    
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
