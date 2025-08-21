class ChangeGenreIdTypeInGraveGenres < ActiveRecord::Migration[6.1]
  def change

    # user_id を bigint に変更
    # ※posts, comments テーブルにあると仮定しています。他のテーブルにもあれば追記してください。
    change_column :posts, :user_id, :bigint
    change_column :comments, :user_id, :bigint

    # grave_id を bigint に変更
    # ※posts, grave_genres テーブルにあると仮定しています。
    change_column :posts, :grave_id, :bigint
    change_column :grave_genres, :grave_id, :bigint

    # ActiveStorage関連のIDを bigint に変更
    change_column :active_storage_attachments, :blob_id, :bigint
    change_column :active_storage_attachments, :record_id, :bigint
    change_column :active_storage_variant_records, :blob_id, :bigint
  

  end
end
