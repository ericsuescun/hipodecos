class AddMarginToStudy < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :margin, :decimal
  end
end
