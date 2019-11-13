class AddEmergencyCelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :emergency_cel, :string
  end
end
