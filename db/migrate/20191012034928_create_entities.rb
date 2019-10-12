class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.string :name
      t.string :initials
      t.string :code
      t.string :mgr_name
      t.string :mgr_email
      t.string :mgr_tel
      t.string :mgr_cel
      t.string :municipality
      t.string :department
      t.string :address
      t.string :entype

      t.timestamps
    end
  end
end
