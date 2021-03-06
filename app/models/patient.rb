class Patient < ApplicationRecord
	def email_required?
	  false
	end

	def email_changed?
	  false
	end

	# For ActiveRecord 5.1+
	def will_save_change_to_email?
	  false
	end

	default_scope -> { order(created_at: :desc) }

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :timeoutable,
	     :rememberable, :authentication_keys => [:id_number]

	has_many :informs, dependent: :destroy
	has_many :diganostics, through: :informs
	has_many :objections, as: :objectionable, dependent: :destroy
	accepts_nested_attributes_for :informs

	validates :id_type, :id_number, :name1, :lastname1, :sex, presence: true
	validates :id_number, uniqueness: true

	before_save { self.name1.to_s.upcase! }
	before_save { self.name2.to_s.upcase! }
	before_save { self.lastname1.to_s.upcase! }
	before_save { self.lastname2.to_s.upcase! }

	def fullname
	  [name1, name2, lastname1, lastname2].join(' ')
	end

	def halfname
	  [name1, lastname1].join(' ')
	end

end
