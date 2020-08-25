require "application_system_test_case"

class OldrecordsTest < ApplicationSystemTestCase
  setup do
    @oldrecord = oldrecords(:one)
  end

  test "visiting the index" do
    visit oldrecords_url
    assert_selector "h1", text: "Oldrecords"
  end

  test "creating a Oldrecord" do
    visit oldrecords_url
    click_on "New Oldrecord"

    fill_in "Apellido", with: @oldrecord.apellido
    fill_in "Apellido2", with: @oldrecord.apellido2
    fill_in "Autoriz", with: @oldrecord.autoriz
    fill_in "Bloque", with: @oldrecord.bloque
    fill_in "Cedula", with: @oldrecord.cedula
    fill_in "Clave", with: @oldrecord.clave
    fill_in "Clinica", with: @oldrecord.clinica
    fill_in "Codigo", with: @oldrecord.codigo
    fill_in "Codigo1", with: @oldrecord.codigo1
    fill_in "Codigo2", with: @oldrecord.codigo2
    fill_in "Codigo3", with: @oldrecord.codigo3
    fill_in "Codigo4", with: @oldrecord.codigo4
    fill_in "Codigo5", with: @oldrecord.codigo5
    fill_in "Codval1", with: @oldrecord.codval1
    fill_in "Codval2", with: @oldrecord.codval2
    fill_in "Codval3", with: @oldrecord.codval3
    fill_in "Dapellido", with: @oldrecord.dapellido
    fill_in "Descr", with: @oldrecord.descr
    fill_in "Diagnostic", with: @oldrecord.diagnostic
    fill_in "Dnombre", with: @oldrecord.dnombre
    fill_in "Dx", with: @oldrecord.dx
    fill_in "Edad", with: @oldrecord.edad
    fill_in "Emb", with: @oldrecord.emb
    fill_in "Entad", with: @oldrecord.entad
    fill_in "Entidad", with: @oldrecord.entidad
    fill_in "Estado", with: @oldrecord.estado
    fill_in "Factura", with: @oldrecord.factura
    fill_in "Fecha", with: @oldrecord.fecha
    fill_in "Fecha1", with: @oldrecord.fecha1
    fill_in "Fecharec", with: @oldrecord.fecharec
    fill_in "Firma", with: @oldrecord.firma
    fill_in "Fsincro", with: @oldrecord.fsincro
    fill_in "Historia", with: @oldrecord.historia
    fill_in "Identif", with: @oldrecord.identif
    fill_in "Imprimir", with: @oldrecord.imprimir
    fill_in "Nombre", with: @oldrecord.nombre
    fill_in "Nombre2", with: @oldrecord.nombre2
    fill_in "Numero", with: @oldrecord.numero
    fill_in "Ocupacion", with: @oldrecord.ocupacion
    fill_in "Oficina", with: @oldrecord.oficina
    fill_in "Patologo", with: @oldrecord.patologo
    fill_in "Por1", with: @oldrecord.por1
    fill_in "Por2", with: @oldrecord.por2
    fill_in "Por3", with: @oldrecord.por3
    fill_in "Prestador", with: @oldrecord.prestador
    fill_in "Rango", with: @oldrecord.rango
    fill_in "Residencia", with: @oldrecord.residencia
    fill_in "Revisor", with: @oldrecord.revisor
    fill_in "Saldo", with: @oldrecord.saldo
    fill_in "Secretaria", with: @oldrecord.secretaria
    fill_in "Secretauno", with: @oldrecord.secretauno
    fill_in "Sexo", with: @oldrecord.sexo
    fill_in "Sincroniza", with: @oldrecord.sincroniza
    fill_in "Telefono", with: @oldrecord.telefono
    fill_in "Tiempo", with: @oldrecord.tiempo
    fill_in "Tipo", with: @oldrecord.tipo
    fill_in "Uniedad", with: @oldrecord.uniedad
    fill_in "Usuario", with: @oldrecord.usuario
    fill_in "Zona", with: @oldrecord.zona
    click_on "Create Oldrecord"

    assert_text "Oldrecord was successfully created"
    click_on "Back"
  end

  test "updating a Oldrecord" do
    visit oldrecords_url
    click_on "Edit", match: :first

    fill_in "Apellido", with: @oldrecord.apellido
    fill_in "Apellido2", with: @oldrecord.apellido2
    fill_in "Autoriz", with: @oldrecord.autoriz
    fill_in "Bloque", with: @oldrecord.bloque
    fill_in "Cedula", with: @oldrecord.cedula
    fill_in "Clave", with: @oldrecord.clave
    fill_in "Clinica", with: @oldrecord.clinica
    fill_in "Codigo", with: @oldrecord.codigo
    fill_in "Codigo1", with: @oldrecord.codigo1
    fill_in "Codigo2", with: @oldrecord.codigo2
    fill_in "Codigo3", with: @oldrecord.codigo3
    fill_in "Codigo4", with: @oldrecord.codigo4
    fill_in "Codigo5", with: @oldrecord.codigo5
    fill_in "Codval1", with: @oldrecord.codval1
    fill_in "Codval2", with: @oldrecord.codval2
    fill_in "Codval3", with: @oldrecord.codval3
    fill_in "Dapellido", with: @oldrecord.dapellido
    fill_in "Descr", with: @oldrecord.descr
    fill_in "Diagnostic", with: @oldrecord.diagnostic
    fill_in "Dnombre", with: @oldrecord.dnombre
    fill_in "Dx", with: @oldrecord.dx
    fill_in "Edad", with: @oldrecord.edad
    fill_in "Emb", with: @oldrecord.emb
    fill_in "Entad", with: @oldrecord.entad
    fill_in "Entidad", with: @oldrecord.entidad
    fill_in "Estado", with: @oldrecord.estado
    fill_in "Factura", with: @oldrecord.factura
    fill_in "Fecha", with: @oldrecord.fecha
    fill_in "Fecha1", with: @oldrecord.fecha1
    fill_in "Fecharec", with: @oldrecord.fecharec
    fill_in "Firma", with: @oldrecord.firma
    fill_in "Fsincro", with: @oldrecord.fsincro
    fill_in "Historia", with: @oldrecord.historia
    fill_in "Identif", with: @oldrecord.identif
    fill_in "Imprimir", with: @oldrecord.imprimir
    fill_in "Nombre", with: @oldrecord.nombre
    fill_in "Nombre2", with: @oldrecord.nombre2
    fill_in "Numero", with: @oldrecord.numero
    fill_in "Ocupacion", with: @oldrecord.ocupacion
    fill_in "Oficina", with: @oldrecord.oficina
    fill_in "Patologo", with: @oldrecord.patologo
    fill_in "Por1", with: @oldrecord.por1
    fill_in "Por2", with: @oldrecord.por2
    fill_in "Por3", with: @oldrecord.por3
    fill_in "Prestador", with: @oldrecord.prestador
    fill_in "Rango", with: @oldrecord.rango
    fill_in "Residencia", with: @oldrecord.residencia
    fill_in "Revisor", with: @oldrecord.revisor
    fill_in "Saldo", with: @oldrecord.saldo
    fill_in "Secretaria", with: @oldrecord.secretaria
    fill_in "Secretauno", with: @oldrecord.secretauno
    fill_in "Sexo", with: @oldrecord.sexo
    fill_in "Sincroniza", with: @oldrecord.sincroniza
    fill_in "Telefono", with: @oldrecord.telefono
    fill_in "Tiempo", with: @oldrecord.tiempo
    fill_in "Tipo", with: @oldrecord.tipo
    fill_in "Uniedad", with: @oldrecord.uniedad
    fill_in "Usuario", with: @oldrecord.usuario
    fill_in "Zona", with: @oldrecord.zona
    click_on "Update Oldrecord"

    assert_text "Oldrecord was successfully updated"
    click_on "Back"
  end

  test "destroying a Oldrecord" do
    visit oldrecords_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Oldrecord was successfully destroyed"
  end
end
