class AddPriceToMaterials < ActiveRecord::Migration[7.1]
  def change
    add_column :materials, :price, :float
  end
end
