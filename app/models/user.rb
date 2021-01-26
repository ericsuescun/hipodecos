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

end
