class ChangeOrganCodeToBeStringInSamples < ActiveRecord::Migration[5.2]
  def up
    change_column :samples, :organ_code, :string
  end

  def down
    change_column :samples, :organ_code, :integer
  end
end
