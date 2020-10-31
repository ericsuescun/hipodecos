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
