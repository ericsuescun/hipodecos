class AddUserIdToAutomatics < ActiveRecord::Migration[5.2]
  def change
    add_column :automatics, :user_id, :integer
  end
end
