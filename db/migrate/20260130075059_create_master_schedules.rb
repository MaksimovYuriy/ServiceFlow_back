class CreateMasterSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :master_schedules do |t|
      t.references :master, null: false, foreign_key: true
      t.integer :weekday, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
