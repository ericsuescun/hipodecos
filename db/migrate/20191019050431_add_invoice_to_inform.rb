class AddInvoiceToInform < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :invoice, :string
  end
end
