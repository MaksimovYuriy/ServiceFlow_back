class CreateMasters < ActiveRecord::Migration[7.1]
  def change
    create_table :masters do |t|
      t.string :full_name
      t.string :phone

      t.timestamps
    end
  end
end
