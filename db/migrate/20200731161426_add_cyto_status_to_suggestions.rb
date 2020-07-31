class AddCytoStatusToSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :cyto_status, :string
  end
end
