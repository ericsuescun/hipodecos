class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.string :organ
      t.string :title

      t.timestamps
    end
  end
end
