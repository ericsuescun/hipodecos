class CreateOldcitos < ActiveRecord::Migration[5.2]
  def change
    create_table :oldcitos do |t|
      t.string :clave
      t.string :numero
      t.date :fecharec
      t.date :fecha
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
      t.string :saldo
      t.string :dnombre
      t.string :dapellido
      t.string :oficina
      t.string :telefono
      t.text :diag
      t.text :notas
      t.text :sugerencia
      t.string :citologa
      t.string :patologo
      t.string :celsup
      t.string :celint
      t.string :celpara
      t.string :plega
      t.string :agrupa
      t.string :prestador
      t.string :factura
      t.string :autoriz
      t.string :usuario
      t.string :ocupacion
      t.string :residencia
      t.string :zona
      t.string :emb
      t.string :estado
      t.string :embarazo
      t.string :fum
      t.string :citprev
      t.string :codigo
      t.string :codcito
      t.string :vinculado
      t.string :secretaria
      t.string :secretauno
      t.date :fecha1
      t.date :fechato
      t.string :resultado
      t.string :imprimir
      t.string :revisor
      t.date :fechanac
      t.string :sincroniza
      t.date :fsincro
      t.string :planifica
      t.string :muestra
      t.string :colade
      t.string :colinad
      t.string :montade
      t.string :montainad

      t.timestamps
    end
  end
end
