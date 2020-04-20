class CreateOrgans < ActiveRecord::Migration[5.2]
  def change
    create_table :organs do |t|
      t.integer :admin_id
      t.string :organ
      t.string :organ_code

      t.timestamps
    end
  end
end
