class AddPAgeTypeToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_age_type, :string
  end
end
