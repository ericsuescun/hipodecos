class AddCoveredToSlides < ActiveRecord::Migration[5.2]
  def change
    add_column :slides, :covered, :boolean, default: false
  end
end
