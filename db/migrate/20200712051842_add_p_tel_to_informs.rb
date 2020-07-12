class AddPTelToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_tel, :string
  end
end
