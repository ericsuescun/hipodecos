class AddFactorToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :factor, :decimal
  end
end
