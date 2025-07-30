class CreateGraves < ActiveRecord::Migration[6.1]
  def change
    create_table :graves do |t|
          t.string :name, null: false
          t.string :address, null: false
          t.float :latitude, null: false
          t.float :longitude, null: false
          t.text :description, null: false
          t.string :prefecture, null: false
    
          t.timestamps
        end


  end
end
