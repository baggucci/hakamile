class AddNoteToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :note, :text
  end
end
