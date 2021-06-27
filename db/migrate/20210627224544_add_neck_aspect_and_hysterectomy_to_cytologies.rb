class AddNeckAspectAndHysterectomyToCytologies < ActiveRecord::Migration[5.2]
  def change
    add_column :cytologies, :neck_aspect, :text
    add_column :cytologies, :hysterectomy, :string
  end
end
