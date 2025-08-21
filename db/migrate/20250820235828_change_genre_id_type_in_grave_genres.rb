class ChangeGenreIdTypeInGraveGenres < ActiveRecord::Migration[6.1]
  def change

      # まず外部キー制約を削除
      remove_foreign_key :grave_genres, :genres

      # カラム型を bigint に変更
      change_column :grave_genres, :genre_id, :bigint
  
      # 外部キー制約を再追加
      add_foreign_key :grave_genres, :genres


  end
end
