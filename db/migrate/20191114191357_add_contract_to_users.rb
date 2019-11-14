class AddContractToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :contract, :string
  end
end
