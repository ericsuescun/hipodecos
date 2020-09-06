class AddCostToStudy < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :cost, :decimal
  end
end
