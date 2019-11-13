class AddEmergencyTelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :emergency_tel, :string
  end
end
