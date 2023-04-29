class AddExtDiagToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :ext_diag, :string, default: ''
  end
end
