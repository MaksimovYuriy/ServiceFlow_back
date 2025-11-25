class CreateServiceMasters < ActiveRecord::Migration[7.1]
  def change
    create_table :service_masters do |t|
      t.references :service, null: false, foreign_key: true
      t.references :master, null: false, foreign_key: true

      t.timestamps
    end
  end
end
