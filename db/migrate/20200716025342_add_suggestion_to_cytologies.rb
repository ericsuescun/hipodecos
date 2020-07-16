class AddSuggestionToCytologies < ActiveRecord::Migration[5.2]
  def change
    add_column :cytologies, :suggestion, :text
  end
end
