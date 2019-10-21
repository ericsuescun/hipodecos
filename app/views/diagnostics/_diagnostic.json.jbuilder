json.extract! diagnostic, :id, :inform_id, :user_id, :description, :created_at, :updated_at
json.url diagnostic_url(diagnostic, format: :json)
