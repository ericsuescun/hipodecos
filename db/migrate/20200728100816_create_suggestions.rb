class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
