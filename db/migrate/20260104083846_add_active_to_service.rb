class AddActiveToService < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :active, :boolean
    change_column :services, :price, :integer
  end
end
