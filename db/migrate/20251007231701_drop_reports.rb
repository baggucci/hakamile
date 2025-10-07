class DropReports < ActiveRecord::Migration[6.1]
  def change
    drop_table :reports
  end
end
