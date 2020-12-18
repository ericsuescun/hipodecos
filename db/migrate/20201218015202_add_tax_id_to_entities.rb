class AddTaxIdToEntities < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :tax_id, :string
  end
end
