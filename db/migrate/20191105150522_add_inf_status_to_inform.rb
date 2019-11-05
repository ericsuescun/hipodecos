class AddInfStatusToInform < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :inf_status, :string
  end
end
