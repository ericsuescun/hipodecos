class ChangeBirthControlToBeStringInCytologies < ActiveRecord::Migration[5.2]
  def up
    change_column :cytologies, :birth_control, :string
  end

  def down
    change_column :cytologies, :birth_control, :integer
  end
end
