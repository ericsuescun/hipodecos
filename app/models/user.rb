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

end
