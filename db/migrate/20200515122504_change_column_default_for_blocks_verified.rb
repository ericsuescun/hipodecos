class ChangeColumnDefaultForBlocksVerified < ActiveRecord::Migration[5.2]
  def up
    change_column :blocks, :verified, :boolean, default: false
  end

  def down
    change_column :blocks, :verified, :boolean, default: nil
  end
end
