class AddPasswordToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :encrypted_password, :string
  end
end
