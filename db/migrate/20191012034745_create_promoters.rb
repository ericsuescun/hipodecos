class CreatePromoters < ActiveRecord::Migration[5.2]
  def change
    create_table :promoters do |t|
      t.string :name
      t.string :initials
      t.string :code

      t.timestamps
    end
  end
end
