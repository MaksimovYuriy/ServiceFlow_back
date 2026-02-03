class ChangeDefaultStatusForNotes < ActiveRecord::Migration[7.1]
  def change
    change_column_default :notes, :status, 0
  end
end
