class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :cvfile, CvfileUploader
  mount_uploader :signfile, SignfileUploader

  validates :first_name, :last_name, :tel, :cel, :address, :birth_date, :join_date, :role_id, presence: true

end
