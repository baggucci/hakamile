class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
      # 索引を追加して検索効率を上げる
      add_index :relationships, :follower_id
      add_index :relationships, :followed_id
      # follower_idとfollowed_idの組み合わせの重複を防ぐ
      add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
