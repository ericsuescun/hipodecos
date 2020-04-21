class AddSystemToOrgans < ActiveRecord::Migration[5.2]
  def change
    add_column :organs, :system, :string
  end
end
