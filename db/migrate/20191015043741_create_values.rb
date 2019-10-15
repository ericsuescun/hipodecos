class CreateValues < ActiveRecord::Migration[5.2]
  def change
    create_table :values do |t|
      t.references :codeval, foreign_key: true
      t.references :cost, foreign_key: true
      t.decimal :value
      t.text :description
      t.integer :admin_id

      t.timestamps
    end
  end
end
