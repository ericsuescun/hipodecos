class AddCytologistToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :cytologist, :integer
  end
end
