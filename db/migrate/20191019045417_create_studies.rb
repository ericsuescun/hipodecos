class CreateStudies < ActiveRecord::Migration[5.2]
  def change
    create_table :studies do |t|
      t.references :inform, foreign_key: true
      t.integer :user_id
      t.integer :codeval_id
      t.integer :factor

      t.timestamps
    end
  end
end
