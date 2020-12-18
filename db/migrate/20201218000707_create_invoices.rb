class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :invoice_code
      t.date :init_date
      t.date :final_date
      t.date :invoice_date
      t.integer :entity_id
      t.string :inf_type
      t.decimal :value
      t.integer :user_id

      t.timestamps
    end
  end
end
