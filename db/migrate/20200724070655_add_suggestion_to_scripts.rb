class AddSuggestionToScripts < ActiveRecord::Migration[5.2]
  def change
    add_column :scripts, :suggestion, :text
  end
end
