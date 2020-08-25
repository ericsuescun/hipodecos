class CreateOldrecords < ActiveRecord::Migration[5.2]
  def change
    create_table :oldrecords do |t|
      t.string :clave
      t.string :numero
      t.string :fecharec
      t.string :fecha
      t.string :apellido
      t.string :apellido2
      t.string :nombre
      t.string :nombre2
      t.string :identif
      t.string :cedula
      t.string :historia
      t.string :uniedad
      t.string :edad
      t.string :sexo
      t.string :clinica
      t.string :entidad
      t.string :entad
      t.string :codval1
      t.string :por1
      t.string :codval2
      t.string :por2
      t.string :codval3
      t.string :por3
      t.string :saldo
      t.text :descr
      t.text :diagnostic
      t.string :codigo
      t.string :codigo1
      t.string :codigo2
      t.string :codigo3
      t.string :codigo4
      t.string :codigo5
      t.string :prestador
      t.string :factura
      t.string :autoriz
      t.string :usuario
      t.string :ocupacion
      t.string :residencia
      t.string :zona
      t.string :emb
      t.string :estado
      t.string :telefono
      t.string :dnombre
      t.string :dapellido
      t.string :oficina
      t.string :bloque
      t.string :patologo
      t.string :secretaria
      t.string :tipo
      t.string :imprimir
      t.string :secretauno
      t.string :fecha1
      t.string :firma
      t.string :rango
      t.string :dx
      t.string :revisor
      t.string :tiempo
      t.string :sincroniza
      t.string :fsincro

      t.timestamps
    end
  end
end
