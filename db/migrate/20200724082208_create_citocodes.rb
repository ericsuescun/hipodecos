class CreateCitocodes < ActiveRecord::Migration[5.2]
  def change
    create_table :citocodes do |t|
      t.integer :admin_id
      t.string :cito_code
      t.text :description
      t.string :result_type
      t.decimal :score
      t.integer :order

      t.timestamps
    end
  end
end
