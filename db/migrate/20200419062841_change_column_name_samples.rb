class ChangeColumnNameSamples < ActiveRecord::Migration[5.2]
  def change
  	rename_column :samples, :sample_tag, :recipient_tag
  end
end
