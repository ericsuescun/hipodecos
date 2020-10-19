class AddPriceToFactor < ActiveRecord::Migration[5.2]
  def change
    add_column :factors, :price, :decimal
  end
end
