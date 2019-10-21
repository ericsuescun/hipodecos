class CreateSlides < ActiveRecord::Migration[5.2]
  def change
    create_table :slides do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.string :slide_tag
      t.boolean :stored

      t.timestamps
    end
  end
end
