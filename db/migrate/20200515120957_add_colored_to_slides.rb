class AddColoredToSlides < ActiveRecord::Migration[5.2]
  def change
    add_column :slides, :colored, :boolean, default: false
  end
end
