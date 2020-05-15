class ChangeColumnDefaultForSamplesIncluded < ActiveRecord::Migration[5.2]
  def up
    change_column :samples, :included, :boolean, default: false
  end

  def down
    change_column :samples, :included, :boolean, default: nil
  end
end
