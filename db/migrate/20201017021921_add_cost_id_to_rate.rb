class AddCostIdToRate < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :cost_id, :integer
  end
end
