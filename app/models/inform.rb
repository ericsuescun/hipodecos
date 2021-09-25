# == Schema Information
#
# Table name: informs
#
#  id                       :bigint           not null, primary key
#  patient_id               :bigint
#  user_id                  :integer
#  physician_id             :integer
#  tag_code                 :string
#  receive_date             :date
#  delivery_date            :datetime
#  user_review_date         :date
#  prmtr_auth_code          :string
#  zone_type                :string
#  pregnancy_status         :string
#  status                   :string
#  regime                   :string
#  promoter_id              :integer
#  entity_id                :integer
#  branch_id                :integer
#  copayment                :decimal(, )
#  cost                     :decimal(, )
#  price                    :decimal(, )
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  invoice                  :string
#  inf_status               :string
#  pathologist_id           :integer
#  pathologist_review_id    :integer
#  administrative_review_id :integer
#  p_age                    :integer
#  p_age_type               :string
#  p_address                :string
#  p_email                  :string
#  p_tel                    :string
#  p_cel                    :string
#  p_occupation             :string
#  p_residence_code         :string
#  p_municipality           :string
#  p_department             :string
#  inf_type                 :string
#  cytologist               :integer
#  download_date            :datetime
#  invoice_date             :date
#
class Inform < ApplicationRecord
  belongs_to :patient, optional: true

  default_scope -> { order(tag_code: :asc, created_at: :asc) }

  scope :cyto, -> { where(inf_type: 'cito') }
  scope :biop, -> { where("inf_type != 'cito'") }
  scope :hosp, -> { where(inf_type: 'hosp') }
  scope :clin, -> { where(inf_type: 'clin') }
  scope :ready, -> { where(inf_status: 'ready')}
  scope :publ_down, -> { where(inf_status: 'published').or(where(inf_status: 'downloaded')) }
  scope :delivery_range, -> (start_date, end_date) { where(delivery_date: start_date..end_date) }
  scope :receive_range, -> (start_date, end_date) { where(receive_date: start_date..end_date) }


  has_many :samples, dependent: :destroy  #Dificulto el borrado automático para evitar catástrofes
  has_many :studies, dependent: :destroy
  has_many :macros, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :slides, dependent: :destroy
  has_many :micros, dependent: :destroy
  has_many :diagnostics, dependent: :destroy
  has_many :recipients, dependent: :destroy
  has_many :physicians, dependent: :destroy
  accepts_nested_attributes_for :physicians
  has_many :cytologies, dependent: :destroy
  accepts_nested_attributes_for :cytologies
  has_many :suggestions, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :objections, as: :objectionable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :branch_id, :zone_type, :receive_date, :inf_type, presence: true

  # before_save :get_tag_code, :get_entity, on: :create

  def get_entity
    self.entity_id = Branch.find(self.branch_id).entity.id
  end

  # def get_regime
  #   if self.promoter_id.present?
  #     self.regime = Promoter.find(self.promoter_id).regime
  #   end
  # end

  # def get_tag_code
  #   if self.inf_type == "clin"
  #      self.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive(self.inf_type).to_s
  #   elsif self.inf_type == "hosp"
  #      self.tag_code = "H" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive(self.inf_type).to_s
  #   elsif self.inf_type == "cito"
  #      self.tag_code = "K" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive(self.inf_type).to_s
  #   end
  # end

  # def next_tag_code(inf_type)
  #   if inf_type == "clin"
  #      tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive(inf_type).to_s
  #   elsif inf_type == "hosp"
  #      tag_code = "H" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive(inf_type).to_s
  #   elsif inf_type == "cito"
  #      tag_code = "K" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive(inf_type).to_s
  #   end
  # end

  # def consecutive(inf_type)
  #   date_range = Time.zone.now.to_date.beginning_of_year..Time.zone.now.to_date.end_of_year
  #   return Inform.where(inf_type: inf_type, created_at: date_range).count + 1
  # end

  def physician
    if physician_id.present?
      Physician.find(physician_id).fullname
    end
  end

  def promoter_name
    if promoter_id.present?
      Promoter.find(promoter_id).name
    end
  end

  def promoter_initials
    if promoter_id.present?
      Promoter.find(promoter_id).initials
    end
  end

  def promoter_code
    if promoter_id.present?
      Promoter.find(promoter_id).code
    end
  end

  def entity_name
    if entity_id.present?
      Entity.find(entity_id).name
    end
  end

  def entity_initials
    if entity_id.present?
      Entity.find(entity_id).initials
    end
  end

  def entity_code
    if entity_id.present?
      Entity.find(entity_id).code
    end
  end

  def branch_name
    if branch_id.present?
      Branch.find(branch_id).name
    end
  end

  def branch_initials
    if branch_id.present?
      Branch.find(branch_id).initials
    end
  end

  def pathologist_fullname
    if pathologist_id.present?
      User.find(pathologist_id).fullname
    end
  end

  def pathologist_initials
    if pathologist_id.present?
      User.find(pathologist_id).initials
    end
  end

  def pathologist_review_fullname
    if pathologist_review_id.present?
      User.find(pathologist_review_id).fullname
    end
  end

  def pathologist_review_initials
    if pathologist_review_id.present?
      User.find(pathologist_review_id).initials
    end
  end

  def cytologist_fullname
    if cytologist.present?
      User.find(cytologist).fullname
    end
  end

  def cytologist_initials
    if cytologist.present?
      User.find(cytologist).initials
    end
  end

  def administrative_review_fullname
    if administrative_review_id.present?
      User.find(administrative_review_id).fullname
    end
  end

  def administrative_review_initials
    if administrative_review_id.present?
      User.find(administrative_review_id).initials
    end
  end

end
