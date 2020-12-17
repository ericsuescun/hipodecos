class AddInvoiceDateToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :invoice_date, :date
  end
end
