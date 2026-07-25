class AddIdentificationToUsers < ActiveRecord::Migration[7.0]
  def change
    # Staff document of identity — needed as the attending professional's cédula
    # in the RIPS JSON. id_number starts blank (to be filled per pathologist);
    # id_type defaults to "CC" (the common case).
    add_column :users, :id_number, :string, default: ""
    add_column :users, :id_type, :string, default: "CC"
  end
end
