class AddPAddressToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_address, :string
  end
end
