class CreatePhysicians < ActiveRecord::Migration[5.2]
  def change
    create_table :physicians do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.string :name
      t.string :lastname
      t.string :tel
      t.string :cel
      t.string :email
      t.string :study1
      t.string :study2

      t.timestamps
    end
  end
end
