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

  # Counts backing the pre-download warning staff see before the file is sent.
  # Both read the SAME `patients` scope that assembles the usuarios array, so
  # the number in the warning can never disagree with the number in the file.
  def usuarios_count
    patients.count
  end

  def usuarios_without_birth_date_count
    patients.where(birth_date: nil).count
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
      # Emitted as "" (not null, and NEVER derived) when the patient has no
      # birth_date. Colombian referral paperwork frequently carries only an age,
      # so ~25% of patients have no DOB on record and the age lives on the
      # inform instead (p_age/p_age_type). Computing a date back from that age
      # would put a fabricated fact in a filing to the health authorities —
      # an unrecorded date is reported as unrecorded. Same convention as the
      # procedures CSV (rips_controller.rb:69).
      fechaNacimiento:              patient.birth_date.present? ? patient.birth_date.strftime("%Y-%m-%d") : "",
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
  # (User#register, e.g. "13115-2006"). Taken verbatim from the pathologist's
  # User (id_type defaults to "CC", id_number is "" until filled in on their
  # profile) so the file generates cleanly whether or not the cédula is set.
  def professional_document(inform)
    user = (User.find_by(id: inform.pathologist_id) if inform.pathologist_id.present?)
    return [nil, nil] unless user

    [user.id_type, user.id_number]
  end

  def codeval_code(codeval_id)
    (@codeval_codes ||= {})[codeval_id] ||= Codeval.find_by(id: codeval_id)&.code
  end
end
