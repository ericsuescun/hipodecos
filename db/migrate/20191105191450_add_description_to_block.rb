class AddDescriptionToBlock < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :description, :text
  end
end
