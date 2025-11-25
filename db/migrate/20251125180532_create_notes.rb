class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.datetime :date
      t.integer :status
      t.float :total_price
      t.references :service, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :master, null: false, foreign_key: true

      t.timestamps
    end
  end
end
