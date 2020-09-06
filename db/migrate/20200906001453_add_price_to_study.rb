class AddPriceToStudy < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :price, :decimal
  end
end
