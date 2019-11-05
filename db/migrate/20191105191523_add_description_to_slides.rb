class AddDescriptionToSlides < ActiveRecord::Migration[5.2]
  def change
    add_column :slides, :description, :text
  end
end
