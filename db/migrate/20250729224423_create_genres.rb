class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.string :name

      t.timestamps
    end
        # ジャンル名は重複しないようにユニーク制約を追加
        add_index :genres, :name, unique: true

  end
end
