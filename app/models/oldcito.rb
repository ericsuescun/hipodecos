# == Schema Information
#
# Table name: oldcitos
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
#  saldo      :string
#  dnombre    :string
#  dapellido  :string
#  oficina    :string
#  telefono   :string
#  diag       :text
#  notas      :text
#  sugerencia :text
#  citologa   :string
#  patologo   :string
#  celsup     :string
#  celint     :string
#  celpara    :string
#  plega      :string
#  agrupa     :string
#  prestador  :string
#  factura    :string
#  autoriz    :string
#  usuario    :string
#  ocupacion  :string
#  residencia :string
#  zona       :string
#  emb        :string
#  estado     :string
#  embarazo   :string
#  fum        :string
#  citprev    :string
#  codigo     :string
#  codcito    :string
#  vinculado  :string
#  secretaria :string
#  secretauno :string
#  fecha1     :date
#  fechato    :date
#  resultado  :string
#  imprimir   :string
#  revisor    :string
#  fechanac   :date
#  sincroniza :string
#  fsincro    :date
#  planifica  :string
#  muestra    :string
#  colade     :string
#  colinad    :string
#  montade    :string
#  montainad  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  patient_id :integer
#
class Oldcito < ApplicationRecord
	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Oldcito.create!(row.to_hash)
		end
	end

	default_scope -> { order(fecharec: :desc, numero: :desc) }

	def fullname
	  [nombre, nombre2, fix_accent(apellido), fix_accent(apellido2)].join(' ')
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

				descr.gsub!("Ã\u008B","Ó")

				descr.gsub!("Â·", "ú")

				descr.gsub!("Ã\u0090", "Ñ")
			
			end
			
			
			
			return descr
		end
end
