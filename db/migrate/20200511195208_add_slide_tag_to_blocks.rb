class AddSlideTagToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :slide_tag, :string
  end
end
