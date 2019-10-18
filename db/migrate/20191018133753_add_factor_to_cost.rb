class AddFactorToCost < ActiveRecord::Migration[5.2]
  def change
    add_column :costs, :factor, :decimal
  end
end
