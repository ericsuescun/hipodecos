class CreateMunicipalities < ActiveRecord::Migration[5.2]
  def change
    create_table :municipalities do |t|
      t.string :code
      t.string :municipality
      t.string :department
      t.integer :order
      t.integer :score

      t.timestamps
    end
  end
end
