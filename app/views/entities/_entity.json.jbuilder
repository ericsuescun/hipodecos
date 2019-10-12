json.extract! entity, :id, :name, :initials, :code, :mgr_name, :mgr_email, :mgr_tel, :mgr_cel, :municipality, :department, :address, :entype, :created_at, :updated_at
json.url entity_url(entity, format: :json)
