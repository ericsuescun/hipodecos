class RemoveEmailRestrictionFromPatients < ActiveRecord::Migration[7.0]
  def change
    change_column_null :patients, :email, true
  end
end
