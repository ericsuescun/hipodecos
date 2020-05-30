class AddDiagnosticToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :diagnostic, :text
  end
end
