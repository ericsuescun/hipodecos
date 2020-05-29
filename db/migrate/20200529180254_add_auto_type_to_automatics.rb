class AddAutoTypeToAutomatics < ActiveRecord::Migration[5.2]
  def change
    add_column :automatics, :auto_type, :string
  end
end
