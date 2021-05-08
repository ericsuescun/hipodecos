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
require 'test_helper'

class OldrecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
