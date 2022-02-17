class AddCancerToDiagcodes < ActiveRecord::Migration[5.2]
  def change
    add_column :diagcodes, :cancer, :boolean, default: false
  end
end
