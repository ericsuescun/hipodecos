class AddKeywordsToOrgans < ActiveRecord::Migration[5.2]
  def change
    add_column :organs, :keywords, :text, array: true, default: []
  end
end
