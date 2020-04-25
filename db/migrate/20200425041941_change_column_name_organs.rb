class ChangeColumnNameOrgans < ActiveRecord::Migration[5.2]
  def change
  	rename_column :organs, :system, :part
  end
end
