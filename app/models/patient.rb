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
	
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :timeoutable,
	     :rememberable, :authentication_keys => [:id_number]
         
	has_many :informs, dependent: :destroy

	# has_many :informs

	has_many :diganostics, through: :informs

	has_many :objections, as: :objectionable, dependent: :destroy
	
	# accepts_nested_attributes_for :informs, allow_destroy: true
	accepts_nested_attributes_for :informs

	default_scope -> { order(created_at: :desc) }

	# validates :id_type, :age_number, :age_type, :name1, :lastname1, :sex, presence: true
	validates :id_type, presence: true

	validates :id_number, uniqueness: true

	def fullname
	  [name1, name2, fix_accent(lastname1), fix_accent(lastname2)].join(' ')
	end

	private
		def fix_accent(descr)
			
			descr.gsub!("Ã\u009F","á")
			
			descr.gsub!("Ã\u009A","é")
			
			descr.gsub!("Ã\u009D","í")

			descr.gsub!("Â¾","ó")

			descr.gsub!("Ã\u008B","Ó")

			descr.gsub!("Â·", "ú")
			
			return descr
		end
	
end
