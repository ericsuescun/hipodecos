class AddDownloadDateToInform < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :download_date, :datetime
  end
end
