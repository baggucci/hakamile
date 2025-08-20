class CreateGraveGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :grave_genres do |t|
      t.references :grave, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      # t.bigint :genre_id
      t.timestamps
    end
  end
end
