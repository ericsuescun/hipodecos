class AddFragmentToSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :fragment, :integer
  end
end
