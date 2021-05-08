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

  default_scope -> { order(created_at: :asc) }

  scope :cyto, -> { where(inf_type: 'cito') }
  scope :biop, -> { where("inf_type != 'cito'") }
  scope :hosp, -> { where(inf_type: 'hosp') }
  scope :clin, -> { where(inf_type: 'clin') }
  scope :ready, -> { where(inf_status: 'ready')}
  scope :publ_down, -> { where(inf_status: 'published').or(where(inf_status: 'downloaded')) }
  scope :delivery_range, -> (start_date, end_date) { where(delivery_date: start_date..end_date) }

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


  # has_many :samples
  # has_many :studies
  # has_many :macros
  # has_many :blocks
  # has_many :slides
  # has_many :micros
  # has_many :diagnostics
  # has_many :pictures, as: :imageable
  # has_many :recipients
  # has_many :physicians
  # accepts_nested_attributes_for :physicians

  validates :zone_type, :receive_date, :inf_type, presence: true

end
