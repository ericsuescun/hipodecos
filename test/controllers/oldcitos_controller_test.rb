require 'test_helper'

class OldcitosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oldcito = oldcitos(:one)
  end

  test "should get index" do
    get oldcitos_url
    assert_response :success
  end

  test "should get new" do
    get new_oldcito_url
    assert_response :success
  end

  test "should create oldcito" do
    assert_difference('Oldcito.count') do
      post oldcitos_url, params: { oldcito: { agrupa: @oldcito.agrupa, apellido: @oldcito.apellido, apellido2: @oldcito.apellido2, autoriz: @oldcito.autoriz, cedula: @oldcito.cedula, celint: @oldcito.celint, celpara: @oldcito.celpara, celsup: @oldcito.celsup, citologa: @oldcito.citologa, citprev: @oldcito.citprev, clave: @oldcito.clave, clinica: @oldcito.clinica, codcito: @oldcito.codcito, codigo: @oldcito.codigo, codval1: @oldcito.codval1, colade: @oldcito.colade, colinad: @oldcito.colinad, dapellido: @oldcito.dapellido, diag: @oldcito.diag, dnombre: @oldcito.dnombre, edad: @oldcito.edad, emb: @oldcito.emb, embarazo: @oldcito.embarazo, entad: @oldcito.entad, entidad: @oldcito.entidad, estado: @oldcito.estado, factura: @oldcito.factura, fecha: @oldcito.fecha, fecha1: @oldcito.fecha1, fechanac: @oldcito.fechanac, fecharec: @oldcito.fecharec, fechato: @oldcito.fechato, fsincro: @oldcito.fsincro, fum: @oldcito.fum, historia: @oldcito.historia, identif: @oldcito.identif, imprimir: @oldcito.imprimir, montade: @oldcito.montade, montainad: @oldcito.montainad, muestra: @oldcito.muestra, nombre: @oldcito.nombre, nombre2: @oldcito.nombre2, notas: @oldcito.notas, numero: @oldcito.numero, ocupacion: @oldcito.ocupacion, oficina: @oldcito.oficina, patologo: @oldcito.patologo, planifica: @oldcito.planifica, plega: @oldcito.plega, por1: @oldcito.por1, prestador: @oldcito.prestador, residencia: @oldcito.residencia, resultado: @oldcito.resultado, revisor: @oldcito.revisor, saldo: @oldcito.saldo, secretaria: @oldcito.secretaria, secretauno: @oldcito.secretauno, sexo: @oldcito.sexo, sincroniza: @oldcito.sincroniza, sugerencia: @oldcito.sugerencia, telefono: @oldcito.telefono, uniedad: @oldcito.uniedad, usuario: @oldcito.usuario, vinculado: @oldcito.vinculado, zona: @oldcito.zona } }
    end

    assert_redirected_to oldcito_url(Oldcito.last)
  end

  test "should show oldcito" do
    get oldcito_url(@oldcito)
    assert_response :success
  end

  test "should get edit" do
    get edit_oldcito_url(@oldcito)
    assert_response :success
  end

  test "should update oldcito" do
    patch oldcito_url(@oldcito), params: { oldcito: { agrupa: @oldcito.agrupa, apellido: @oldcito.apellido, apellido2: @oldcito.apellido2, autoriz: @oldcito.autoriz, cedula: @oldcito.cedula, celint: @oldcito.celint, celpara: @oldcito.celpara, celsup: @oldcito.celsup, citologa: @oldcito.citologa, citprev: @oldcito.citprev, clave: @oldcito.clave, clinica: @oldcito.clinica, codcito: @oldcito.codcito, codigo: @oldcito.codigo, codval1: @oldcito.codval1, colade: @oldcito.colade, colinad: @oldcito.colinad, dapellido: @oldcito.dapellido, diag: @oldcito.diag, dnombre: @oldcito.dnombre, edad: @oldcito.edad, emb: @oldcito.emb, embarazo: @oldcito.embarazo, entad: @oldcito.entad, entidad: @oldcito.entidad, estado: @oldcito.estado, factura: @oldcito.factura, fecha: @oldcito.fecha, fecha1: @oldcito.fecha1, fechanac: @oldcito.fechanac, fecharec: @oldcito.fecharec, fechato: @oldcito.fechato, fsincro: @oldcito.fsincro, fum: @oldcito.fum, historia: @oldcito.historia, identif: @oldcito.identif, imprimir: @oldcito.imprimir, montade: @oldcito.montade, montainad: @oldcito.montainad, muestra: @oldcito.muestra, nombre: @oldcito.nombre, nombre2: @oldcito.nombre2, notas: @oldcito.notas, numero: @oldcito.numero, ocupacion: @oldcito.ocupacion, oficina: @oldcito.oficina, patologo: @oldcito.patologo, planifica: @oldcito.planifica, plega: @oldcito.plega, por1: @oldcito.por1, prestador: @oldcito.prestador, residencia: @oldcito.residencia, resultado: @oldcito.resultado, revisor: @oldcito.revisor, saldo: @oldcito.saldo, secretaria: @oldcito.secretaria, secretauno: @oldcito.secretauno, sexo: @oldcito.sexo, sincroniza: @oldcito.sincroniza, sugerencia: @oldcito.sugerencia, telefono: @oldcito.telefono, uniedad: @oldcito.uniedad, usuario: @oldcito.usuario, vinculado: @oldcito.vinculado, zona: @oldcito.zona } }
    assert_redirected_to oldcito_url(@oldcito)
  end

  test "should destroy oldcito" do
    assert_difference('Oldcito.count', -1) do
      delete oldcito_url(@oldcito)
    end

    assert_redirected_to oldcitos_url
  end
end
