class AddPResidenceCodeToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_residence_code, :string
  end
end
