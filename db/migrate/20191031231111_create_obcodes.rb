class CreateObcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :obcodes do |t|
      t.integer :admin_id
      t.string :title
      t.string :process
      t.decimal :score
      t.integer :order

      t.timestamps
    end
  end
end
