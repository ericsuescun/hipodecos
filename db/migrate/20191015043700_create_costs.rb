class CreateCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :costs do |t|
      t.string :name
      t.text :description
      t.integer :admin_id

      t.timestamps
    end
  end
end
