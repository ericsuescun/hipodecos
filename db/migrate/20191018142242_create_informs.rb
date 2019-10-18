class CreateInforms < ActiveRecord::Migration[5.2]
  def change
    create_table :informs do |t|
      t.integer :user_id
      t.integer :physician_id
      t.string :tag_code
      t.date :receive_date
      t.date :delivery_date
      t.string :prmtr_auth_code
      t.integer :zone_type
      t.integer :pregnancy_status
      t.integer :status
      t.integer :regime
      t.integer :entity_id
      t.integer :branch_id
      t.decimal :copayment
      t.decimal :cost
      t.decimal :price

      t.timestamps
    end
  end
end
