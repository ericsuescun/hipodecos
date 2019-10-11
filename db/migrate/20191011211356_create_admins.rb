class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :tel
      t.string :cel
      t.string :address
      t.boolean :god_mode
      t.boolean :reports_only

      t.timestamps
    end
  end
end
