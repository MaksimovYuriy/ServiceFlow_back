class RequiredQuantityToInteger < ActiveRecord::Migration[7.1]
  def up
    change_column :service_materials, :required_quantity, :integer
  end

  def down
    change_column :service_materials, :required_quantity, :float
  end
end
