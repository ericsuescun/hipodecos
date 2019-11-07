class CreateAutos < ActiveRecord::Migration[5.2]
  def change
    create_table :autos do |t|
      t.references :diagcode, foreign_key: true
      t.integer :user_id
      t.integer :admin_id
      t.string :title
      t.text :body
      t.string :param1
      t.string :param2
      t.string :param3
      t.string :param4
      t.string :param5

      t.timestamps
    end
  end
end
