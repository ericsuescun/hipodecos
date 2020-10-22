class Oldrecord < ApplicationRecord

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Oldrecord.create!(row.to_hash)
		end
	end

	default_scope -> { order(fecharec: :desc) }

	def fullname
	  [nombre, nombre2, apellido, apellido2].join(' ')
	end

	def oldrecord_tag
		[clave, fecharec.strftime("%y"), "-", numero].join('')
	end
end
