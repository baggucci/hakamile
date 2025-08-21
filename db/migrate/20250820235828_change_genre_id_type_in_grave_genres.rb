class ChangeGenreIdTypeInGraveGenres < ActiveRecord::Migration[6.1]
  def change

      # カラム型を bigint に変更
      change_column :grave_genres, :genre_id, :bigint
  

  end
end
