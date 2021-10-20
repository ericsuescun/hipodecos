class AddConsecutiveToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :consecutive, :integer
  end
end
