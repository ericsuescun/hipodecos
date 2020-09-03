class AddEnabledToPromoters < ActiveRecord::Migration[5.2]
  def change
    add_column :promoters, :enabled, :boolean
  end
end
