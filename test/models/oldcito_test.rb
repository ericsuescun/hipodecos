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
require 'test_helper'

class OldcitoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
