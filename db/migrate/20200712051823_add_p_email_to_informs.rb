class AddPEmailToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :p_email, :string
  end
end
