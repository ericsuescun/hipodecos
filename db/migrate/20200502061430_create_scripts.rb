class CreateScripts < ActiveRecord::Migration[5.2]
  def change
    create_table :scripts do |t|
      t.references :template, foreign_key: true
      t.string :script_type
      t.text :description
      t.integer :param1
      t.integer :param2
      t.integer :script_order

      t.timestamps
    end
  end
end
