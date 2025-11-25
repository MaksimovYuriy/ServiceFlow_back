class CreateMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :materials do |t|
      t.string :title
      t.float :quantity
      t.float :minimal_quantity

      t.timestamps
    end
  end
end
