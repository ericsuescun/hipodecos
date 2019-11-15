class AddPssCodeToDiagnostics < ActiveRecord::Migration[5.2]
  def change
    add_column :diagnostics, :pss_code, :string
  end
end
