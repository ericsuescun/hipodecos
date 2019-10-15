class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer :admin_id
      t.string :name
      t.text :description
      t.decimal :rate
      t.decimal :time
      t.decimal :health_care_rate
      t.decimal :pension_rate
      t.decimal :parafiscal_rate

      t.timestamps
    end
  end
end
