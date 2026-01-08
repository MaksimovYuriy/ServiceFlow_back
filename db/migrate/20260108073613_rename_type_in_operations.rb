class RenameTypeInOperations < ActiveRecord::Migration[7.1]
  def change
    rename_column :material_operations, :type, :operation_type
  end
end
