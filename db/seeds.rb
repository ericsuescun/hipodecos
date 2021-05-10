require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.where(notes: "fakes")
if users.present?
  users.destroy_all
end

role = Role.where(name: "Patologia").first

pathologist_user = User.new(
  first_name: Faker::Name.male_first_name,
  last_name: Faker::Name.last_name,
  # email2: Faker::Email.internet.email,
  tel: Faker::Number.between(from: 2, to: 5).to_s + Faker::Number.number(digits: 6).to_s,
  cel: "3" + Faker::Number.between(from: 10, to: 50).to_s + Faker::Number.between(from: 2, to: 9).to_s + Faker::Number.number(digits: 6).to_s,
  birth_date: Faker::Date.birthday(min_age: 28, max_age: 80),
  join_date: Faker::Date.between(from: 35.years.ago, to: 3.months.ago),
  active: true,
  deactivation_date: nil,
  last_admin_id: nil,
  notes: "fakes",
  role_id: role.id,
  # email: Faker::Email.internet.email,
  email: "test@gmail.com",
  password: "12345678",
  password_confirmation: "12345678",
  address: "CL CR",
  emergency_contact: Faker::Name.name,
  emergency_tel: Faker::Number.between(from: 2, to: 5).to_s + Faker::Number.number(digits: 6).to_s,
  emergency_cel: "3" + Faker::Number.between(from: 10, to: 50).to_s + Faker::Number.between(from: 2, to: 9).to_s + Faker::Number.number(digits: 6).to_s
  )


patients = Patient.where(department: "fakes")
if patients.present?
  patients.destroy_all
end

(1..10).each do |n|
  patient = Patient.create!(
    id_number: Faker::Number.unique.number(digits: 8),
    id_type: "CC",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 75),
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
  if patient.sex == 'M'
    patient.update(
      name1: Faker::Name.male_first_name,
      name2: Faker::Name.male_first_name,
      lastname1: Faker::Name.last_name,
      lastname2: Faker::Name.last_name,
      )
  end
  patient.update(created_at: Faker::Date.backward(days: 8))

  (1..10).each do |m|
    inform = patient.informs.build
    inform.user_id = 1
    inform.physician_id = 1

    inform.created_at = Faker::Date.backward(days: 8)
    inform.receive_date = inform.created_at - 1.day

  end
end



