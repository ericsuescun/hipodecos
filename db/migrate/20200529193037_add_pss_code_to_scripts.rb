class AddPssCodeToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :pss_code, :string
  end
end
