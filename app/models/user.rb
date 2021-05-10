# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string
#  last_name              :string
#  email2                 :string
#  tel                    :string
#  cel                    :string
#  birth_date             :date
#  join_date              :date
#  active                 :boolean
#  deactivation_date      :date
#  last_admin_id          :integer
#  notes                  :text
#  role_id                :integer
#  file_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  address                :string
#  emergency_contact      :string
#  emergency_tel          :string
#  emergency_cel          :string
#  cvfile                 :string
#  signfile               :string
#  contract               :string
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:email]

  mount_uploader :cvfile, CvfileUploader
  mount_uploader :signfile, SignfileUploader
  mount_uploader :contract, ContractUploader

  validates :first_name, :last_name, :tel, :cel, :address, :birth_date, :join_date, :role_id, presence: true

  def fullname
    [first_name, last_name].join(' ')
  end

  def initials
    init = []
    init << first_name[0]
    init << first_name.split(' ')[1].first if first_name.split(' ')[1] != nil
    init << last_name[0]
    init << last_name.split(' ')[1].first if last_name.split(' ')[1] != nil
    init.join('')
  end

  def role
    Role.find(role_id).name
  end

end
