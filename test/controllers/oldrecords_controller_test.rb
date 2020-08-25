require 'test_helper'

class OldrecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oldrecord = oldrecords(:one)
  end

  test "should get index" do
    get oldrecords_url
    assert_response :success
  end

  test "should get new" do
    get new_oldrecord_url
    assert_response :success
  end

  test "should create oldrecord" do
    assert_difference('Oldrecord.count') do
      post oldrecords_url, params: { oldrecord: { apellido: @oldrecord.apellido, apellido2: @oldrecord.apellido2, autoriz: @oldrecord.autoriz, bloque: @oldrecord.bloque, cedula: @oldrecord.cedula, clave: @oldrecord.clave, clinica: @oldrecord.clinica, codigo: @oldrecord.codigo, codigo1: @oldrecord.codigo1, codigo2: @oldrecord.codigo2, codigo3: @oldrecord.codigo3, codigo4: @oldrecord.codigo4, codigo5: @oldrecord.codigo5, codval1: @oldrecord.codval1, codval2: @oldrecord.codval2, codval3: @oldrecord.codval3, dapellido: @oldrecord.dapellido, descr: @oldrecord.descr, diagnostic: @oldrecord.diagnostic, dnombre: @oldrecord.dnombre, dx: @oldrecord.dx, edad: @oldrecord.edad, emb: @oldrecord.emb, entad: @oldrecord.entad, entidad: @oldrecord.entidad, estado: @oldrecord.estado, factura: @oldrecord.factura, fecha: @oldrecord.fecha, fecha1: @oldrecord.fecha1, fecharec: @oldrecord.fecharec, firma: @oldrecord.firma, fsincro: @oldrecord.fsincro, historia: @oldrecord.historia, identif: @oldrecord.identif, imprimir: @oldrecord.imprimir, nombre: @oldrecord.nombre, nombre2: @oldrecord.nombre2, numero: @oldrecord.numero, ocupacion: @oldrecord.ocupacion, oficina: @oldrecord.oficina, patologo: @oldrecord.patologo, por1: @oldrecord.por1, por2: @oldrecord.por2, por3: @oldrecord.por3, prestador: @oldrecord.prestador, rango: @oldrecord.rango, residencia: @oldrecord.residencia, revisor: @oldrecord.revisor, saldo: @oldrecord.saldo, secretaria: @oldrecord.secretaria, secretauno: @oldrecord.secretauno, sexo: @oldrecord.sexo, sincroniza: @oldrecord.sincroniza, telefono: @oldrecord.telefono, tiempo: @oldrecord.tiempo, tipo: @oldrecord.tipo, uniedad: @oldrecord.uniedad, usuario: @oldrecord.usuario, zona: @oldrecord.zona } }
    end

    assert_redirected_to oldrecord_url(Oldrecord.last)
  end

  test "should show oldrecord" do
    get oldrecord_url(@oldrecord)
    assert_response :success
  end

  test "should get edit" do
    get edit_oldrecord_url(@oldrecord)
    assert_response :success
  end

  test "should update oldrecord" do
    patch oldrecord_url(@oldrecord), params: { oldrecord: { apellido: @oldrecord.apellido, apellido2: @oldrecord.apellido2, autoriz: @oldrecord.autoriz, bloque: @oldrecord.bloque, cedula: @oldrecord.cedula, clave: @oldrecord.clave, clinica: @oldrecord.clinica, codigo: @oldrecord.codigo, codigo1: @oldrecord.codigo1, codigo2: @oldrecord.codigo2, codigo3: @oldrecord.codigo3, codigo4: @oldrecord.codigo4, codigo5: @oldrecord.codigo5, codval1: @oldrecord.codval1, codval2: @oldrecord.codval2, codval3: @oldrecord.codval3, dapellido: @oldrecord.dapellido, descr: @oldrecord.descr, diagnostic: @oldrecord.diagnostic, dnombre: @oldrecord.dnombre, dx: @oldrecord.dx, edad: @oldrecord.edad, emb: @oldrecord.emb, entad: @oldrecord.entad, entidad: @oldrecord.entidad, estado: @oldrecord.estado, factura: @oldrecord.factura, fecha: @oldrecord.fecha, fecha1: @oldrecord.fecha1, fecharec: @oldrecord.fecharec, firma: @oldrecord.firma, fsincro: @oldrecord.fsincro, historia: @oldrecord.historia, identif: @oldrecord.identif, imprimir: @oldrecord.imprimir, nombre: @oldrecord.nombre, nombre2: @oldrecord.nombre2, numero: @oldrecord.numero, ocupacion: @oldrecord.ocupacion, oficina: @oldrecord.oficina, patologo: @oldrecord.patologo, por1: @oldrecord.por1, por2: @oldrecord.por2, por3: @oldrecord.por3, prestador: @oldrecord.prestador, rango: @oldrecord.rango, residencia: @oldrecord.residencia, revisor: @oldrecord.revisor, saldo: @oldrecord.saldo, secretaria: @oldrecord.secretaria, secretauno: @oldrecord.secretauno, sexo: @oldrecord.sexo, sincroniza: @oldrecord.sincroniza, telefono: @oldrecord.telefono, tiempo: @oldrecord.tiempo, tipo: @oldrecord.tipo, uniedad: @oldrecord.uniedad, usuario: @oldrecord.usuario, zona: @oldrecord.zona } }
    assert_redirected_to oldrecord_url(@oldrecord)
  end

  test "should destroy oldrecord" do
    assert_difference('Oldrecord.count', -1) do
      delete oldrecord_url(@oldrecord)
    end

    assert_redirected_to oldrecords_url
  end
end
