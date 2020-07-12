class AddPMunicipalityToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_municipality, :string
  end
end
