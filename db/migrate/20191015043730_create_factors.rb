class CreateFactors < ActiveRecord::Migration[5.2]
  def change
    create_table :factors do |t|
      t.references :codeval, foreign_key: true
      t.references :rate, foreign_key: true
      t.decimal :factor
      t.text :description
      t.integer :admin_id

      t.timestamps
    end
  end
end
