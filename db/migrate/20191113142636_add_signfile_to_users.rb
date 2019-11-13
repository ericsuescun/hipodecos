class AddSignfileToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :signfile, :string
  end
end
