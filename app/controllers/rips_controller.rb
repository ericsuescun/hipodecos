class RipsController < ApplicationController
  def procedures
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    attributes = %w[num_DocumentoIdObligado	consecutivoUsuario	codPrestador	fechaInicioAtencion	idMIPRES
                    numAutorizacion	codProcedimiento	viaIngresoServicioSalud	modalidadGrupoServicioTecSal	grupoServicios
                    codServicio	finalidadTecnologiaSalud	tipoDocumentoIdentificacion	numDocumentoIdentificacion	codDiagnosticoPrincipal
                    codDiagnosticoRelacionado	codComplicacion	vrServicio	conceptoRecaudo	valorPagoModerador	numFEVPagoModerador	consecutivo help]

    csv_file = CSV.generate(headers: true) do |csv|
      csv << attributes

      Patient.joins(:informs).where({informs: { delivery_date: date_range, invoice: params[:invoice] }}).distinct.find_each do |patient|
        patient_index_counter = 1

        patient.informs.where(delivery_date: date_range, invoice: params[:invoice]).publ_down.each do |inform|
          inform.studies.each do |study|
            study.factor&.times do
              csv << [
                "900363326", inform.patient.id_number, "050011134601", inform.delivery_date.strftime("%Y-%m-%d %H:%M"), "",
                inform.prmtr_auth_code, Codeval.find(study.codeval_id).code, "05", "01", "04",
                "203", "15", inform.patient.id_type, inform.patient.id_number, inform.main_diagnostic_code,
                inform.related_diagnostic_code, "", study.price, inform.copayment.present? ? "01" : "05", inform.copayment.blank? ? "0" : inform.copayment, inform.invoice, patient_index_counter,
                inform.main_diagnostic_code.blank? ? inform.diagnostics.first.description : ""
              ]

              patient_index_counter += 1
            end
          end
        end
      end
    end

    send_data csv_file, filename: "procedimientos_factura_#{params[:invoice]}_entre_#{initial_date.strftime("%Y-%m-%d")}_y_#{final_date.strftime("%Y-%m-%d")}.csv"
  end

  def users
    initial_date = Date.parse(params[:init_date]).beginning_of_day
    final_date = Date.parse(params[:final_date]).end_of_day
    date_range = initial_date..final_date

    attributes = %w[tipoDocumentoIdentificacion	numDocumentoIdentificacion	num_DocumentoIdObligado	tipoUsuario
                    fechaNacimiento	codSexo	codPaisResidencia	codMunicipioResidencia	codZonaTerritorialResidencia
                    incapacidad	codPaisOrigen	consecutivo]

    csv_file = CSV.generate(headers: true) do |csv|
      csv << attributes

      patient_index_counter = 1

      Patient.joins(:informs).where({informs: { delivery_date: date_range, invoice: params[:invoice] }}).distinct.find_each do |patient|
        csv << [
          patient.id_type, patient.id_number, "900363326", patient.informs.first.regime == "Contributivo" ? "01" : "04",
          patient.birth_date.present? ? patient.birth_date.strftime("%Y-%m-%d") : "", patient.sex, patient.id_type != "PT" ? 170 : 862, "05001",
          patient.informs.first.zone_type == "U" ? "02" : "01", "NO", patient.id_type != "PT" ? 170 : 862, patient_index_counter
        ]

        patient_index_counter += 1
      end
    end

    send_data csv_file, filename: "usuarios_factura_#{params[:invoice]}_entre_#{initial_date.strftime("%Y-%m-%d")}_y_#{final_date.strftime("%Y-%m-%d")}.csv"
  end
end
