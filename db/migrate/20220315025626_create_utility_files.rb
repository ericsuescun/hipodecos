class CreateUtilityFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :utility_files do |t|
      t.string :name
      t.string :filepath
      t.text :description

      t.timestamps
    end
  end
end
