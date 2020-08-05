class ChangeColumnNameCytologies < ActiveRecord::Migration[5.2]
  def change
  	rename_column :cytologies, :result, :last_result
  end
end
