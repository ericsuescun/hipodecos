class AddRateIdToEntity < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :rate_id, :integer
  end
end
