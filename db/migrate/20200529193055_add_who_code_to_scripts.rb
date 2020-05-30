class AddWhoCodeToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :who_code, :string
  end
end
