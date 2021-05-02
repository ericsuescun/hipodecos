require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

patients = Patient.where(department: "fakes")
if patients.present?
  patients.destroy_all
end

(1..10).each do |n|
  patient = Patient.create!(
    id_number: Faker::Number.unique.number(digits: 8),
    id_type: "CC",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 75),
    age_number: Faker::Number.within(range: 18..75),
    age_type: 'A',
    name1: Faker::Name.female_first_name,
    name2: Faker::Name.female_first_name,
    lastname1: Faker::Name.last_name,
    lastname2: Faker::Name.last_name,
    sex: ['M', 'F'].sample,
    gender: "",
    address: "",
    email: "",
    tel: "",
    cel: "",
    occupation: "",
    residence_code: "",
    municipality: "",
    department: "fakes",
  )
  if patient.sex == 'F'
    patient.update(
      name1: Faker::Name.female_first_name,
      name2: Faker::Name.female_first_name,
      lastname1: Faker::Name.last_name,
      lastname2: Faker::Name.last_name,
    )
  else
    patient.update(
      name1: Faker::Name.male_first_name,
      name2: Faker::Name.male_first_name,
      lastname1: Faker::Name.last_name,
      lastname2: Faker::Name.last_name,
      )
  end
  patient.update(created_at: Faker::Date.backward(days: 8))

  (1..10).each do |m|
    inform = patient.informs.build(
      user_id: 1,
      physician_id: 1,
      receive_date: Faker::Date.backward(days: 8),

    )
  end
end



