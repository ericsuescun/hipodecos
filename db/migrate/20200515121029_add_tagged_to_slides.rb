class AddTaggedToSlides < ActiveRecord::Migration[5.2]
  def change
    add_column :slides, :tagged, :boolean, default: false
  end
end
