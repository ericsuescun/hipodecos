class AddPatientIdToOldrecord < ActiveRecord::Migration[5.2]
  def change
    add_column :oldrecords, :patient_id, :integer
  end
end
