class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: true
      t.references :reported, null: false, foreign_key: true
      t.references :reportable, polymorphic: true, null: false
      t.integer :reason
      t.integer :status

      t.timestamps
    end
  end
end
