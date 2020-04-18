class CreateRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :recipients do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.string :tag
      t.text :description
      t.integer :samples

      t.timestamps
    end
  end
end
