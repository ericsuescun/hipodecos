class AddCytoStatusToMicros < ActiveRecord::Migration[5.2]
  def change
    add_column :micros, :cyto_status, :string
  end
end
