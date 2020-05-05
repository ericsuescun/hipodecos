class AddOrganToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :organ, :string
  end
end
