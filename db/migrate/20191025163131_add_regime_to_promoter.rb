class AddRegimeToPromoter < ActiveRecord::Migration[5.2]
  def change
    add_column :promoters, :regime, :string
  end
end
