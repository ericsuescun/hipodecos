class CreateCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :costs do |t|
      t.references :codeval, foreign_key: true
      t.decimal :cost

      t.timestamps
    end
  end
end
