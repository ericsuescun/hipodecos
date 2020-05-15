class AddBlockedToSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :blocked, :boolean, default: false
  end
end
