class AddCytoStatusToDiagnostics < ActiveRecord::Migration[5.2]
  def change
    add_column :diagnostics, :cyto_status, :string
  end
end
