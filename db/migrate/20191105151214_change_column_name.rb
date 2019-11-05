class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
  	rename_column :codevals, :oms_code, :ref_code
  end
end
