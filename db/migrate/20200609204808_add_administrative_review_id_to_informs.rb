class AddAdministrativeReviewIdToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :administrative_review_id, :integer
  end
end
