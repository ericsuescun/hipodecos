class AddOrganCodeToDiagcodes < ActiveRecord::Migration[5.2]
  def change
    add_column :diagcodes, :organ_code, :integer
  end
end
