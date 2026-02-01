class AddStartAtAndEndAtToNotes < ActiveRecord::Migration[7.1]
  def change
    remove_column :notes, :date, :datetime

    add_column :notes, :start_at, :datetime, null: false
    add_column :notes, :end_at, :datetime, null: false
  end
end
