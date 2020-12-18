json.extract! invoice, :id, :invoice_code, :init_date, :final_date, :invoice_date, :entity_id, :inf_type, :value, :user_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
