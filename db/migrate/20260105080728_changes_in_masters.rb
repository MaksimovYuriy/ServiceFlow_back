class ChangesInMasters < ActiveRecord::Migration[7.1]
  def change
    remove_column :masters, :full_name, :string

    add_column :masters, :first_name, :string
    add_column :masters, :middle_name, :string
    add_column :masters, :last_name, :string
    add_column :masters, :salary, :integer
    add_column :masters, :active, :boolean
  end
end
