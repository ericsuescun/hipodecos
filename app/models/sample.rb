# == Schema Information
#
# Table name: samples
#
#  id            :bigint           not null, primary key
#  inform_id     :bigint
#  user_id       :integer
#  name          :string
#  description   :text
#  recipient_tag :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sample_tag    :string
#  organ_code    :string
#  fragment      :integer
#  slide_tag     :string
#  included      :boolean          default(FALSE)
#  blocked       :boolean          default(FALSE)
#
class Sample < ApplicationRecord
  belongs_to :inform

  default_scope -> { order(sample_tag: :asc) }

  # enum organ_code: { Corazon: 1, Pericardio: 2, Arterias: 3, Venas: 4, Linfaticos: 5, ARNSN: 6, Laringe: 7, Traquea: 8, Bronquios: 9, Pulmones: 10, Pleura: 11, Bazo: 12, Medula_Osea: 13, Ganglio_Linfatico: 14, Amigdalas: 15, Mucosa_Oral_y_Lengua: 16, Glandulas_Salivares: 17, Esofago: 18, Estomago: 19, Duodeno: 20, Intestino_Delgado: 21, Apendice: 22, Intestino_Grueso_y_Recto: 23, Peritoneo: 24, Higado: 25, Vias_Biliares: 26, Pancreas: 27, Aparato_Urinario_Rinon: 28, Ureteres: 29, Vejiga: 30, Uretra: 31, Testiculo_Epididimo_Vias_Deferentes: 32, Vesiculas_Seminales: 33, Mama: 34, Prostata: 35, Vagina: 36, Cervix_y_Endocervix: 37, Cuerpo_Uterino_y_Endometrio: 38, Trompas_Uterinas: 39, Ovario: 40, Feto_Placenta_y_Anexos: 41, Pineal: 42, Suprarrenales: 43, Hiposfisis: 44, Tiroides: 45, Paratiroides: 46, Sistema_Nervioso_Central: 47, Meninges: 48, Sistema_Nervioso_Periferico: 49, Ojo: 50, Oido: 51, Piel_y_Tejidos_Blandos_Subcutaneos: 52, Musculo_y_sus_Envolturas: 53, Hueso_y_Cartilago: 54, Articulaciones: 55, Dientes_y_Anexos: 56, VIH_Asociado_a_Otra_Infeccion: 421, VIH_Asociado_a_Citomelago: 422, VIH_Asociado_a_Candida: 423, VIH_Asociado_a_Neumocystis: 424, VIH_Asociado_a_Kaposi: 427, VIH_Asociado_a_Sin_Especificacion: 439, VIH_Asociado_a_Citomegalia: 785, Granuloma_Caseificado: 1000000, Granuloma_No_Caseificado: 1000100, Tumor_Neuroendocrino: 1000200, Adenoca_Bien_Diferenciado: 1000300, Adenoca_Moderada_Diferenciada: 1000400, Adenoca_Poco_Diferenciado: 1000500, Ca_Espini_Bien_Diferenciado: 1000600, Ca_Espini_Median_Diferenciado: 1000700, Leiomioma: 1000800, Absceso: 1000900, Bordes_de_Rx_Suficientes: 1001000, Bordes_de_Rx_Comprometidos: 1001000, Papiloma_Virus_Pvh: 794}

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  has_many :pictures, as: :imageable, dependent: :destroy
  # has_many :pictures, as: :imageable

  default_scope -> { order(created_at: :asc) }

  validates :sample_tag, presence: true
end
