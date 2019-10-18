class AddBaseToCost < ActiveRecord::Migration[5.2]
  def change
    add_column :costs, :base, :integer
  end
end
