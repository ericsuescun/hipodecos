class AddFragmentToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :fragment, :integer
  end
end
