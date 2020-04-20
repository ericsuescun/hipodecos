class AddOrganCodeToSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :organ_code, :integer
  end
end
