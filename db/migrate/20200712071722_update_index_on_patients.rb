class UpdateIndexOnPatients < ActiveRecord::Migration[5.2]
  def up
    sql = 'DROP INDEX index_patients_on_email'
    sql << ' ON patients' if Rails.env == 'production' # Heroku pg
    ActiveRecord::Base.connection.execute(sql)
  end
end
