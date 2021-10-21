class AddRegisterToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :register, :string
  end
end
