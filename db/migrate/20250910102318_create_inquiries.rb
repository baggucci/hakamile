class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :category, null: false
      t.integer :status, null: false, default: 0 # デフォルト値を「0: 未対応」に設定
      t.text :message, null: false
      t.references :linkable, polymorphic: true # こちらは空でもOKなので null: false は付けない

      t.timestamps
    end
  end
end