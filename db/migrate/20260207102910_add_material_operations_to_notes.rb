class AddMaterialOperationsToNotes < ActiveRecord::Migration[7.1]
  def change
    add_reference :material_operations, :note, foreign_key: true
  end
end
