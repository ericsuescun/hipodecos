class AddCostIdToEntity < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :cost_id, :integer
  end
end
