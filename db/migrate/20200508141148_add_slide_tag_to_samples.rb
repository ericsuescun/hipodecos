class AddSlideTagToSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :slide_tag, :string
  end
end
