class AddPathologistReviewIdToInforms < ActiveRecord::Migration[5.2]
  def change
    add_column :informs, :pathologist_review_id, :integer
  end
end
