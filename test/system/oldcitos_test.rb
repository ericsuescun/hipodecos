require "application_system_test_case"

class OldcitosTest < ApplicationSystemTestCase
  setup do
    @oldcito = oldcitos(:one)
  end

  test "visiting the index" do
    visit oldcitos_url
    assert_selector "h1", text: "Oldcitos"
  end

  test "creating a Oldcito" do
    visit oldcitos_url
    click_on "New Oldcito"

    fill_in "Agrupa", with: @oldcito.agrupa
    fill_in "Apellido", with: @oldcito.apellido
    fill_in "Apellido2", with: @oldcito.apellido2
    fill_in "Autoriz", with: @oldcito.autoriz
    fill_in "Cedula", with: @oldcito.cedula
    fill_in "Celint", with: @oldcito.celint
    fill_in "Celpara", with: @oldcito.celpara
    fill_in "Celsup", with: @oldcito.celsup
    fill_in "Citologa", with: @oldcito.citologa
    fill_in "Citprev", with: @oldcito.citprev
    fill_in "Clave", with: @oldcito.clave
    fill_in "Clinica", with: @oldcito.clinica
    fill_in "Codcito", with: @oldcito.codcito
    fill_in "Codigo", with: @oldcito.codigo
    fill_in "Codval1", with: @oldcito.codval1
    fill_in "Colade", with: @oldcito.colade
    fill_in "Colinad", with: @oldcito.colinad
    fill_in "Dapellido", with: @oldcito.dapellido
    fill_in "Diag", with: @oldcito.diag
    fill_in "Dnombre", with: @oldcito.dnombre
    fill_in "Edad", with: @oldcito.edad
    fill_in "Emb", with: @oldcito.emb
    fill_in "Embarazo", with: @oldcito.embarazo
    fill_in "Entad", with: @oldcito.entad
    fill_in "Entidad", with: @oldcito.entidad
    fill_in "Estado", with: @oldcito.estado
    fill_in "Factura", with: @oldcito.factura
    fill_in "Fecha", with: @oldcito.fecha
    fill_in "Fecha1", with: @oldcito.fecha1
    fill_in "Fechanac", with: @oldcito.fechanac
    fill_in "Fecharec", with: @oldcito.fecharec
    fill_in "Fechato", with: @oldcito.fechato
    fill_in "Fsincro", with: @oldcito.fsincro
    fill_in "Fum", with: @oldcito.fum
    fill_in "Historia", with: @oldcito.historia
    fill_in "Identif", with: @oldcito.identif
    fill_in "Imprimir", with: @oldcito.imprimir
    fill_in "Montade", with: @oldcito.montade
    fill_in "Montainad", with: @oldcito.montainad
    fill_in "Muestra", with: @oldcito.muestra
    fill_in "Nombre", with: @oldcito.nombre
    fill_in "Nombre2", with: @oldcito.nombre2
    fill_in "Notas", with: @oldcito.notas
    fill_in "Numero", with: @oldcito.numero
    fill_in "Ocupacion", with: @oldcito.ocupacion
    fill_in "Oficina", with: @oldcito.oficina
    fill_in "Patologo", with: @oldcito.patologo
    fill_in "Planifica", with: @oldcito.planifica
    fill_in "Plega", with: @oldcito.plega
    fill_in "Por1", with: @oldcito.por1
    fill_in "Prestador", with: @oldcito.prestador
    fill_in "Residencia", with: @oldcito.residencia
    fill_in "Resultado", with: @oldcito.resultado
    fill_in "Revisor", with: @oldcito.revisor
    fill_in "Saldo", with: @oldcito.saldo
    fill_in "Secretaria", with: @oldcito.secretaria
    fill_in "Secretauno", with: @oldcito.secretauno
    fill_in "Sexo", with: @oldcito.sexo
    fill_in "Sincroniza", with: @oldcito.sincroniza
    fill_in "Sugerencia", with: @oldcito.sugerencia
    fill_in "Telefono", with: @oldcito.telefono
    fill_in "Uniedad", with: @oldcito.uniedad
    fill_in "Usuario", with: @oldcito.usuario
    fill_in "Vinculado", with: @oldcito.vinculado
    fill_in "Zona", with: @oldcito.zona
    click_on "Create Oldcito"

    assert_text "Oldcito was successfully created"
    click_on "Back"
  end

  test "updating a Oldcito" do
    visit oldcitos_url
    click_on "Edit", match: :first

    fill_in "Agrupa", with: @oldcito.agrupa
    fill_in "Apellido", with: @oldcito.apellido
    fill_in "Apellido2", with: @oldcito.apellido2
    fill_in "Autoriz", with: @oldcito.autoriz
    fill_in "Cedula", with: @oldcito.cedula
    fill_in "Celint", with: @oldcito.celint
    fill_in "Celpara", with: @oldcito.celpara
    fill_in "Celsup", with: @oldcito.celsup
    fill_in "Citologa", with: @oldcito.citologa
    fill_in "Citprev", with: @oldcito.citprev
    fill_in "Clave", with: @oldcito.clave
    fill_in "Clinica", with: @oldcito.clinica
    fill_in "Codcito", with: @oldcito.codcito
    fill_in "Codigo", with: @oldcito.codigo
    fill_in "Codval1", with: @oldcito.codval1
    fill_in "Colade", with: @oldcito.colade
    fill_in "Colinad", with: @oldcito.colinad
    fill_in "Dapellido", with: @oldcito.dapellido
    fill_in "Diag", with: @oldcito.diag
    fill_in "Dnombre", with: @oldcito.dnombre
    fill_in "Edad", with: @oldcito.edad
    fill_in "Emb", with: @oldcito.emb
    fill_in "Embarazo", with: @oldcito.embarazo
    fill_in "Entad", with: @oldcito.entad
    fill_in "Entidad", with: @oldcito.entidad
    fill_in "Estado", with: @oldcito.estado
    fill_in "Factura", with: @oldcito.factura
    fill_in "Fecha", with: @oldcito.fecha
    fill_in "Fecha1", with: @oldcito.fecha1
    fill_in "Fechanac", with: @oldcito.fechanac
    fill_in "Fecharec", with: @oldcito.fecharec
    fill_in "Fechato", with: @oldcito.fechato
    fill_in "Fsincro", with: @oldcito.fsincro
    fill_in "Fum", with: @oldcito.fum
    fill_in "Historia", with: @oldcito.historia
    fill_in "Identif", with: @oldcito.identif
    fill_in "Imprimir", with: @oldcito.imprimir
    fill_in "Montade", with: @oldcito.montade
    fill_in "Montainad", with: @oldcito.montainad
    fill_in "Muestra", with: @oldcito.muestra
    fill_in "Nombre", with: @oldcito.nombre
    fill_in "Nombre2", with: @oldcito.nombre2
    fill_in "Notas", with: @oldcito.notas
    fill_in "Numero", with: @oldcito.numero
    fill_in "Ocupacion", with: @oldcito.ocupacion
    fill_in "Oficina", with: @oldcito.oficina
    fill_in "Patologo", with: @oldcito.patologo
    fill_in "Planifica", with: @oldcito.planifica
    fill_in "Plega", with: @oldcito.plega
    fill_in "Por1", with: @oldcito.por1
    fill_in "Prestador", with: @oldcito.prestador
    fill_in "Residencia", with: @oldcito.residencia
    fill_in "Resultado", with: @oldcito.resultado
    fill_in "Revisor", with: @oldcito.revisor
    fill_in "Saldo", with: @oldcito.saldo
    fill_in "Secretaria", with: @oldcito.secretaria
    fill_in "Secretauno", with: @oldcito.secretauno
    fill_in "Sexo", with: @oldcito.sexo
    fill_in "Sincroniza", with: @oldcito.sincroniza
    fill_in "Sugerencia", with: @oldcito.sugerencia
    fill_in "Telefono", with: @oldcito.telefono
    fill_in "Uniedad", with: @oldcito.uniedad
    fill_in "Usuario", with: @oldcito.usuario
    fill_in "Vinculado", with: @oldcito.vinculado
    fill_in "Zona", with: @oldcito.zona
    click_on "Update Oldcito"

    assert_text "Oldcito was successfully updated"
    click_on "Back"
  end

  test "destroying a Oldcito" do
    visit oldcitos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Oldcito was successfully destroyed"
  end
end
