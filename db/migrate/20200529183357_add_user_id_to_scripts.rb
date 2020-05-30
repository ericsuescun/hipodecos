class AddUserIdToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :user_id, :integer
  end
end
