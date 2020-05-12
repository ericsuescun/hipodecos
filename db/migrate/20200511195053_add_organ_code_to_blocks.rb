class AddOrganCodeToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :organ_code, :string
  end
end
