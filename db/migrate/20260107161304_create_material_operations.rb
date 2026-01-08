class CreateMaterialOperations < ActiveRecord::Migration[7.1]
  def change
    create_table :material_operations do |t|
      t.integer :amount
      t.integer :type
      t.integer :status
      t.integer :source
      t.references :material, null: false, foreign_key: true

      t.timestamps
    end
  end
end
