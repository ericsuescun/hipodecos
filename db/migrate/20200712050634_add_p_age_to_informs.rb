class AddPAgeToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_age, :integer
  end
end
