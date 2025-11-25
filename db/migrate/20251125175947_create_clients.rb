class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :full_name
      t.string :phone
      t.string :telegram

      t.timestamps
    end
  end
end
