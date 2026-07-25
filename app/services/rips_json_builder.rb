# Builds the RIPS-JSON document (Resolución 1036 de 2022, mod. 2806 de 2026)
# for a single factura, reusing the exact field mappings that RipsController's
# `procedures`/`users` CSVs already produce — but assembled into the nested
# structure the MinSalud validator expects:
#
#   { numDocumentoIdObligado, numFactura, tipoNota, numNota,
#     usuarios: [ { <user fields>, servicios: { procedimientos: [ ... ] } } ] }
#
# Scope decision (option A): this only GENERATES the JSON file so staff can
# validate it on the MinSalud site. It does not submit, and it does not attach
# the DIAN electronic-invoice XML (numFactura here is Inform#invoice).
class RipsJsonBuilder
  NIT           = "900363326"      # numDocumentoIdObligado (lab NIT)
  COD_PRESTADOR = "050011134601"   # REPS habilitation code of the lab (not a person)

  # TEMPORARY placeholder cédula for the attending professional. RIPS needs the
  # pathologist's document of identity, but User does not store one yet (adding
  # id_type/id_number is a deferred DB change). Until then we "burn" a single
  # cédula so the file validates end-to-end; professional_document swaps in the
  # real per-pathologist value automatically once User#id_number exists.
  PLACEHOLDER_PROFESSIONAL = ["CC", "17117540"].freeze

  def initialize(invoice:, init_date:, final_date:)
    @invoice = invoice
    @range   = init_date.beginning_of_day..final_date.end_of_day
  end

  def document
    {
      numDocumentoIdObligado: NIT,
      numFactura:             @invoice,
      tipoNota:               nil,
      numNota:                nil,
      usuarios:               usuarios
    }
  end

  def to_json_string
    JSON.pretty_generate(document)
  end

  private

  def usuarios
    consecutivo = 0
    patients.map do |patient|
      consecutivo += 1
      user_object(patient, consecutivo)
    end
  end

  def patients
    Patient.joins(:informs)
           .where(informs: { delivery_date: @range, invoice: @invoice })
           .distinct
  end

  def informs_of(patient)
    patient.informs.where(delivery_date: @range, invoice: @invoice).publ_down
  end

  def user_object(patient, consecutivo)
    first_inform = informs_of(patient).first
    {
      tipoDocumentoIdentificacion:  patient.id_type,
      numDocumentoIdentificacion:   patient.id_number,
      tipoUsuario:                  first_inform&.regime == "Contributivo" ? "01" : "04",
      fechaNacimiento:              patient.birth_date&.strftime("%Y-%m-%d"),
      codSexo:                      patient.sex,
      codPaisResidencia:            patient.id_type == "PT" ? "862" : "170",
      codMunicipioResidencia:       "05001",
      codZonaTerritorialResidencia: first_inform&.zone_type == "U" ? "02" : "01",
      incapacidad:                  "NO",
      consecutivo:                  consecutivo,
      codPaisOrigen:                patient.id_type == "PT" ? "862" : "170",
      servicios:                    { procedimientos: procedimientos_of(patient) }
    }
  end

  def procedimientos_of(patient)
    consecutivo = 0
    procedimientos = []
    informs_of(patient).each do |inform|
      prof_type, prof_num = professional_document(inform)
      inform.studies.each do |study|
        (study.factor || 1).to_i.times do
          consecutivo += 1
          procedimientos << {
            codPrestador:                 COD_PRESTADOR,
            fechaInicioAtencion:          inform.delivery_date&.strftime("%Y-%m-%d %H:%M"),
            idMIPRES:                     nil,
            numAutorizacion:              inform.prmtr_auth_code.presence,
            codProcedimiento:             codeval_code(study.codeval_id),
            viaIngresoServicioSalud:      "05",
            modalidadGrupoServicioTecSal: "01",
            grupoServicios:               "04",
            codServicio:                  203,
            finalidadTecnologiaSalud:     "15",
            tipoDocumentoIdentificacion:  prof_type,
            numDocumentoIdentificacion:   prof_num,
            codDiagnosticoPrincipal:      inform.main_diagnostic_code.presence,
            codDiagnosticoRelacionado:    inform.related_diagnostic_code.presence,
            codComplicacion:              nil,
            vrServicio:                   study.price.to_i,
            tipoPagoModerador:            inform.copayment.present? ? "01" : "05",
            valorPagoModerador:           inform.copayment.to_i,
            numFEVPagoModerador:          inform.invoice,
            consecutivo:                  consecutivo
          }
        end
      end
    end
    procedimientos
  end

  # RIPS identifies the professional who performed the procedure by their
  # DOCUMENT OF IDENTITY (cédula) — NOT the professional registry code
  # (User#register, e.g. "13115-2006"). Once User stores id_type/id_number this
  # returns the real per-pathologist cédula; until then it falls back to the
  # burned-in PLACEHOLDER_PROFESSIONAL so the file still validates.
  def professional_document(inform)
    user = (User.find_by(id: inform.pathologist_id) if inform.pathologist_id.present?)

    if user&.respond_to?(:id_number) && user.id_number.present?
      [user.respond_to?(:id_type) ? user.id_type : "CC", user.id_number]
    else
      PLACEHOLDER_PROFESSIONAL
    end
  end

  def codeval_code(codeval_id)
    (@codeval_codes ||= {})[codeval_id] ||= Codeval.find_by(id: codeval_id)&.code
  end
end
