class AddPDepartmentToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_department, :string
  end
end
