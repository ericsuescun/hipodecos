class AddPOccupationToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_occupation, :string
  end
end
