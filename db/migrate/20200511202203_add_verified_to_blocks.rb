class AddVerifiedToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :verified, :boolean
  end
end
