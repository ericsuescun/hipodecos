json.extract! user, :id, :first_name, :last_name, :email2, :tel, :cel, :birth_date, :join_date, :active, :deactivation_date, :last_admin_id, :notes, :role_id, :file_id, :created_at, :updated_at
json.url user_url(user, format: :json)
