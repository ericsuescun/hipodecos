class ChangeColumnEmailPatients < ActiveRecord::Migration[5.2]
  def up
    change_column :patients, :email, :string, null: false, default: ""
  end

  def down
    change_column :patients, :email, :string
  end
end
