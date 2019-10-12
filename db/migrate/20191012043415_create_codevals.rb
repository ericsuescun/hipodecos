class CreateCodevals < ActiveRecord::Migration[5.2]
  def change
    create_table :codevals do |t|
      t.string :code
      t.text :description
      t.string :origin_system
      t.string :oms_code

      t.timestamps
    end
  end
end
