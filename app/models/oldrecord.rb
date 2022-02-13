# == Schema Information
#
# Table name: oldrecords
#
#  id         :bigint           not null, primary key
#  clave      :string
#  numero     :string
#  fecharec   :date
#  fecha      :date
#  apellido   :string
#  apellido2  :string
#  nombre     :string
#  nombre2    :string
#  identif    :string
#  cedula     :string
#  historia   :string
#  uniedad    :string
#  edad       :string
#  sexo       :string
#  clinica    :string
#  entidad    :string
#  entad      :string
#  codval1    :string
#  por1       :string
#  codval2    :string
#  por2       :string
#  codval3    :string
#  por3       :string
#  saldo      :string
#  descr      :text
#  diagnostic :text
#  codigo     :string
#  codigo1    :string
#  codigo2    :string
#  codigo3    :string
#  codigo4    :string
#  codigo5    :string
#  prestador  :string
#  factura    :string
#  autoriz    :string
#  usuario    :string
#  ocupacion  :string
#  residencia :string
#  zona       :string
#  emb        :string
#  estado     :string
#  telefono   :string
#  dnombre    :string
#  dapellido  :string
#  oficina    :string
#  bloque     :string
#  patologo   :string
#  secretaria :string
#  tipo       :string
#  imprimir   :string
#  secretauno :string
#  fecha1     :date
#  firma      :string
#  rango      :string
#  dx         :string
#  revisor    :string
#  tiempo     :string
#  sincroniza :string
#  fsincro    :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  patient_id :integer
#
class Oldrecord < ApplicationRecord

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Oldrecord.create!(row.to_hash)
		end
	end

	default_scope -> { order(fecharec: :desc, numero: :desc) }

	serialize :apellido, EncryptedField.new
	serialize :apellido2, EncryptedField.new
	serialize :nombre, EncryptedField.new
	serialize :nombre2, EncryptedField.new
	serialize :identif, EncryptedField.new
	serialize :cedula, EncryptedField.new
	serialize :historia, EncryptedField.new
	serialize :uniedad, EncryptedField.new
	serialize :edad, EncryptedField.new
	serialize :sexo, EncryptedField.new
	serialize :usuario, EncryptedField.new
	serialize :ocupacion, EncryptedField.new
	serialize :residencia, EncryptedField.new
	serialize :zona, EncryptedField.new
	serialize :emb, EncryptedField.new
	serialize :estado, EncryptedField.new
	serialize :telefono, EncryptedField.new
	serialize :dnombre, EncryptedField.new
	serialize :dapellido, EncryptedField.new
	serialize :oficina, EncryptedField.new

	def fullname
	  [nombre, nombre2, fix_accent(apellido), fix_accent(apellido2)].join(' ')
	end

	def oldrecord_tag
		[clave, fecharec.strftime("%y"), "-", numero].join('')
	end

	def tag_code
		[clave, fecharec.strftime("%y"), "-", numero].join('')
	end

	private
		def fix_accent(descr)
			if descr
				descr.gsub!("Ã\u009F","á")
				
				descr.gsub!("Ã\u009A","é")
				
				descr.gsub!("Ã\u009D","í")

				descr.gsub!("Â¾","ó")

				descr.gsub!("¾","ó")

				descr.gsub!("Ã\u008B","Ó")

				descr.gsub!("Â·", "ú")

				descr.gsub!("Ã\u0090", "Ñ")
			
			end
			
			
			
			return descr
		end
end
