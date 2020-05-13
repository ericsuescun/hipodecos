class AddIncludedToSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :included, :boolean
  end
end
