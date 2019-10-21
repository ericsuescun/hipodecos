class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.string :block_tag
      t.boolean :stored

      t.timestamps
    end
  end
end
