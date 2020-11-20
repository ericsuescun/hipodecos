class ChangeDeliveryDateToDatetimeInInforms < ActiveRecord::Migration[5.2]
  def up
  	change_column :informs, :delivery_date, :datetime
  end

  def down
  	change_column :informs, :delivery_date, :date
  end
end
