class AddWhoCodeToDiagnostics < ActiveRecord::Migration[5.2]
  def change
    add_column :diagnostics, :who_code, :string
  end
end
