class CreateObjections < ActiveRecord::Migration[5.2]
  def change
    create_table :objections do |t|
      t.references :objectionable, polymorphic: true
      t.integer :user_id
      t.string :name
      t.integer :responsible_user_id
      t.integer :close_user_id
      t.date :close_date
      t.text :description
      t.boolean :closed

      t.timestamps
    end
  end
end
