class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      t.string :id_number
      t.integer :id_type
      t.date :birth_date
      t.integer :age_number
      t.integer :age_type
      t.string :name1
      t.string :name2
      t.string :lastname1
      t.string :lastname2
      t.integer :sex
      t.integer :gender
      t.string :address
      t.string :email
      t.string :tel
      t.string :cel
      t.string :occupation
      t.string :residence_code
      t.string :municipality
      t.string :department

      t.timestamps
    end
  end
end
