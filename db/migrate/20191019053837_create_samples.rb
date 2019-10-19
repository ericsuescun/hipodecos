class CreateSamples < ActiveRecord::Migration[5.2]
  def change
    create_table :samples do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :specimen_tag

      t.timestamps
    end
  end
end
