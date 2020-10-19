class AddCostIdToFactor < ActiveRecord::Migration[5.2]
  def change
    add_column :factors, :cost_id, :integer
  end
end
