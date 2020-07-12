class AddInfTypeToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :inf_type, :string
  end
end
