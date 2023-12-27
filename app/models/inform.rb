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

  # default_scope -> { order(created_at: :asc, tag_code: :asc) }
  scope :by_tagcode, -> { order(tag_code: :asc) }
  scope :by_created_at, -> { order(created_at: :asc) }

  scope :cyto, -> { where(inf_type: 'cito') }
  scope :biop, -> { where(inf_type: 'clin').or(where(inf_type: 'hosp')) }
  scope :hosp, -> { where(inf_type: 'hosp') }
  scope :clin, -> { where(inf_type: 'clin') }
  
  scope :delivery_range, -> (start_date, end_date) { where(delivery_date: start_date..end_date) }
  scope :receive_range, -> (start_date, end_date) { where(receive_date: start_date..end_date) }

  scope :not_assigned, -> { where(pathologist_id: nil) }

  scope :ready, -> { where(inf_status: 'ready')}
  scope :publ_down, -> { where(inf_status: 'published').or(where(inf_status: 'downloaded')) }
  scope :pending, -> { where(inf_status: nil) }
  scope :not_ready, -> { where(inf_status: nil) }
  scope :not_ready_or_cyto, -> { where(inf_status: nil).or(where(inf_status: 'revision_cyto')) }
  scope :revision, -> { where(inf_status: "revision") }


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

  def slides_ok?
    self.slides.count == self.slides.colored.covered.tagged.count && self.slides.count != 0
  end

  def path_assigned?
    self.pathologist_id != nil
  end

  def cyto_assigned?
    self.cytologist != nil
  end

  def cyto_pos_ins?
    if self.diagnostics.present?
      self.diagnostics.first.result == 'positiva' || self.diagnostics.first.result == 'insatisfactoria' || self.diagnostics.first.result == 'negativa+'
    end
  end

  def cyto_neg?
    self.diagnostics.first.result == 'negativa' if self.diagnostics.present?
  end

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

  def cito?
    self.inf_type == 'cito'
  end

  def publ_down?
    return self.inf_status == 'published' || self.inf_status == 'downloaded'
  end

  def cancer?
    return if self.cito?

    diags = self.diagnostics

    return unless diags

    cancer = false
    diags.each do |diag|
      cancer ||= Diagcode.where(id: diag.diagcode_id).take.cancer
    end
    cancer
  end

  def cups_codes
    inform_codes = ""
    self.studies.each do |inform_study|
      inform_codes += Codeval.find(inform_study.codeval_id).code + "(x#{inform_study.factor}) " if inform_study.codeval_id.present?
    end

    inform_codes
  end

  def cups_value
    inform_value = 0
    self.studies.each do |study|
      inform_value += study.price * study.factor
    end

    inform_value.to_i
  end
end
