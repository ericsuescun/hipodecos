json.extract! patient, :id, :id_number, :id_type, :birth_date, :age_number, :age_type, :name1, :name2, :lastname1, :lastname2, :sex, :gender, :address, :email, :tel, :cel, :occupation, :residence_code, :municipality, :department, :created_at, :updated_at
json.url patient_url(patient, format: :json)
