class AddCvfileToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cvfile, :string
  end
end
