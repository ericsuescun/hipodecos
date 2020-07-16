class CreateCytologies < ActiveRecord::Migration[5.2]
  def change
    create_table :cytologies do |t|
      t.references :inform, foreign_key: true
      t.integer :pregnancies
      t.string :last_mens
      t.string :prev_appo
      t.date :sample_date
      t.string :result
      t.integer :birth_control

      t.timestamps
    end
  end
end
