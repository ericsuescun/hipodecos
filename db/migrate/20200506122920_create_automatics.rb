class CreateAutomatics < ActiveRecord::Migration[5.2]
  def change
    create_table :automatics do |t|
      t.string :organ
      t.string :title

      t.timestamps
    end
  end
end
