class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email2
      t.string :tel
      t.string :cel
      t.date :birth_date
      t.date :join_date
      t.boolean :active
      t.date :deactivation_date
      t.integer :last_admin_id
      t.text :notes
      t.integer :role_id
      t.integer :file_id

      t.timestamps
    end
  end
end
