class AddPCelToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_cel, :string
  end
end
