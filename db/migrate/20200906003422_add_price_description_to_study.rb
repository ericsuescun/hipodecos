class AddPriceDescriptionToStudy < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :price_description, :text
  end
end
