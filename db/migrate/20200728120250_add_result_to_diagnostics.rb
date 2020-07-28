class AddResultToDiagnostics < ActiveRecord::Migration[5.2]
  def change
    add_column :diagnostics, :result, :string
  end
end
