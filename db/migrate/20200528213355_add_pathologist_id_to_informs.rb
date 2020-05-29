class AddPathologistIdToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :pathologist_id, :integer
  end
end
