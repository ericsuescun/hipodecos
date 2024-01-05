class AddCorporateToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :corporate, :boolean, default: false
  end
end
