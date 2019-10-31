class CreateDiagcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :diagcodes do |t|
      t.integer :admin_id
      t.string :organ
      t.string :feature1
      t.string :feature2
      t.string :feature3
      t.string :feature4
      t.string :feature5
      t.text :description
      t.string :pss_code
      t.string :who_code
      t.decimal :score
      t.integer :order

      t.timestamps
    end
  end
end
