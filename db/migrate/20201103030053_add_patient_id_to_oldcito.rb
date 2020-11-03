class AddPatientIdToOldcito < ActiveRecord::Migration[5.2]
  def change
    add_column :oldcitos, :patient_id, :integer
  end
end
