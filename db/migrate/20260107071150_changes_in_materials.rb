class ChangesInMaterials < ActiveRecord::Migration[7.1]
  def up
    change_column :materials, :quantity, :integer
    change_column :materials, :minimal_quantity, :integer
  end

  def down
    change_column :materials, :quantity, :float
    change_column :materials, :minimal_quantity, :float
  end
end
