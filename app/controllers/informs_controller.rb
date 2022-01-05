class InformsController < ApplicationController

  require 'zip'

  before_action :authenticate_user!
  before_action :set_inform, only: [:show, :show_revision, :edit, :update, :destroy, :preview, :descr_micro, :clear_revision, :set_revision, :set_ready, :autos_micro, :anulate]

  # GET /informs
  # GET /informs.json
  def index
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    if params[:tag_code]
      @informs = Inform.where(tag_code: params[:tag_code]).order(:consecutive).paginate(page: params[:page], per_page: 10)
    else
      @informs = Inform.where(receive_date: date_range, inf_type: params[:inf_type]).order(:consecutive).order(tag_code: :asc).paginate(page: params[:page], per_page: 60)
    end
  end

  def index_pending
    @informs = Inform.where(inf_type: params[:inf_type]).pending.order(:consecutive).paginate(page: params[:page], per_page: 60)
  end

  def index_oldrecords
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    @oldrecords = Oldrecord.where(fecharec: date_range, clave: params[:inf_type] == 'clin' ? "C" : params[:inf_type] == 'hosp' ? "H" : "K").paginate(page: params[:page], per_page: 60)
  end

  def index_oldcitos
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @oldcitos = Oldcito.where(fecharec: date_range, clave: "K").paginate(page: params[:page], per_page: 60)
  end

  def last20
    @informs = Inform.all.limit(20)
    @oldrecords = Oldrecord.all.limit(20)
    # @informs = []
  end

  def index_revision
    @tab = :revision
    
    
    if role_admin_allowed?
      @informs = Inform.unscoped.where(inf_status: "revision").order(inf_type: :asc, consecutive: :asc).paginate(page: params[:page], per_page: 60)
    else
      @informs = Inform.unscoped.where(inf_status: "revision", pathologist_id: current_user.id).order(inf_type: :asc, consecutive: :asc).paginate(page: params[:page], per_page: 60)
    end
    
  end

  def show_revision
    @organs = Organ.all

    @automatics = Automatic.all
    @automatics_macro = Automatic.where(auto_type: "macro")
    @automatics_micro = Automatic.where(auto_type: "micro")


    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks

    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end

    if @inform.inf_type == 'cito'
      @cytologies = @inform.cytologies
    end
  end

  def index_ready
    @tab = :ready
    
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
      @informs = Inform.where(delivery_date: date_range, inf_status: "ready")
    else
      @informs = Inform.where(inf_status: "ready")
    end
    
  end

  def publish
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "published", delivery_date: Time.now})
    redirect_to informs_index_published_path
  end

  def index_published
    @tab = :published
    serializer = [:id, :tag_code, :delivery_date, :pathologist_review_id, :promoter_id, :branch_id, :prmtr_auth_code,:inf_type, :invoice, :receive_date, :patient_id]

    if params[:init_date].present?
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    # @informs = Inform.where(delivery_date: date_range, inf_status: "published").or(Inform.where(delivery_date: date_range, inf_status: "downloaded")).paginate(page: params[:page], per_page: 10)
    @informs = Inform.select(serializer).delivery_range(initial_date, final_date).publ_down.paginate(page: params[:page], per_page: 10)
  end

  def unpublish
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "ready"})
    if params[:init_date]
      redirect_to informs_index_ready_path + "?init_date=#{params[:init_date]}&final_date=#{params[:final_date]}"
    else
      redirect_to informs_index_ready_path
    end
  end

  def index_downloaded
    @tab = :published

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(download_date: date_range, inf_status: "downloaded").paginate(page: params[:page], per_page: 10)
  end

  def undownload
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "published"})
    if params[:init_date]
      redirect_to informs_index_published_path + "?init_date=#{params[:init_date]}&final_date=#{params[:final_date]}"
    else
      redirect_to informs_index_published_path
    end
  end

  def view_export_foxpro
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range).or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range))
  end

  def export_foxpro
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    informs = Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range).or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range)).order(tag_code: :asc)

    file = ""
    file_name = 1

    # filename = "exp_fox_" + params[:inf_type] + "_" + params[:init_date] + "_a_" + params[:final_date] + ".zip"

    if params[:inf_type] == 'clin'
      filename = "clin.zip"
    elsif params[:inf_type] == 'hosp'
      filename = "hosp.zip"
    elsif params[:inf_type] == 'cito'
      filename = "cit1.zip"
    elsif params[:inf_type] == 'cito2'
      filename = "cit2.zip"
    end

    begin
      Zip::File.open("temp_file.zip", Zip::File::CREATE) do |zipfile|

        informs.each_with_index do |inform, idx|

          if params[:inf_type] != 'cito'
            descr = ""
            inform.recipients.each_with_index do |recipient, n|
              descr += "Contenido de recipiente \##{n + 1}:" + "\r\n" + recipient.description.to_s + "\r\n" + "Bloqueado de la siguiente manera:\r\n\r\n"
              inform.samples.where(recipient_tag: recipient.tag).each do |sample|
                if sample.name == "Cassette"
                  descr += sample.description.to_s
                  descr += ": " if sample.description != ""
                  descr += sample.fragment.to_s + "F-" + get_nomen(sample.sample_tag) + "\r\n"
                else
                  descr += sample.description.to_s + "-" + get_nomen(sample.sample_tag) + "\r\n"
                end
              end
              descr += "\r\n"
            end
            descr += "DESCRIPCIÓN MICROSCÓPICA\r\n\r\n"
            inform.micros.each do |micro|
              if micro.description.size > 500
                descr += "\r\n" + "\r\n" + micro.description + "\r\n "
              else
                descr += micro.description + " "
              end
            end

            zipfile.get_output_stream("#{file_name}.TXT") { |f| f.puts(descr) }

            file_name += 1

            diag = ""
            inform.diagnostics.each do |diagnostic|
              diag += diagnostic.description + " "
            end

            zipfile.get_output_stream("#{file_name}.TXT") { |f| f.puts(diag) }

            file_name += 1
          end


          file += '"' + inform.tag_code[0].to_s + '"' + "," #SE ESTA COLANDO ALGO AQUI
          file += inform.tag_code[4..-1].to_s + ","
          file += inform.receive_date.strftime("%d/%m/%Y") + ","
          file += inform.delivery_date.strftime("%d/%m/%Y") + ","
          file += '"' + inform.patient.lastname1.to_s.upcase + '"' + ","
          file += '"' + inform.patient.lastname2.to_s.upcase + '"' + ","
          file += '"' + inform.patient.name1.to_s.upcase + '"' + ","
          file += '"' + inform.patient.name2.to_s.upcase + '"' + ","
          file += '"' + inform.patient.id_type.to_s + '"' + ","
          file += '"' + inform.patient.id_number.to_s + '"' + ","
          file += '"",' #Historia, se supone que ese campo ya no se usa
          if inform.p_age_type == nil || inform.p_age_type == ""
            file += '"",'
          else
            if inform.p_age_type == "A"
              file += '"' + "1" + '",'
            elsif inform.p_age_type == "M"
              file += '"' + "2" + '",'
            elsif inform.p_age_type == "D"
              file += '"' + "3" + '",'
            end
          end

          if inform.p_age == nil || inform.p_age == ""
            file += '"",'
          else
            file += '"' + inform.p_age.to_s + '"' + ","
          end


          file += '"' + inform.patient.sex.to_s + '"' + ","

          # file += '"' + Entity.where(id: inform.entity_id).first.try(:initials).to_s + '"' + ","
          file += '"' + Branch.where(id: inform.branch_id).first.try(:initials).to_s + '"' + ","

          file += '"' + Promoter.where(id: inform.promoter_id).first.try(:initials).to_s + '"' + ","


          file += '"' + Branch.where(id: inform.branch_id).first.try(:code).to_s + '"' + ","


          file += '"' + Codeval.where(id: inform.studies.first.codeval_id).first.try(:code).to_s + '"' + ","
          file += inform.studies.first.factor.to_s + ","

          if params[:inf_type] != 'cito'
            if inform.studies.second != nil
              file += '"' + Codeval.where(id: inform.studies.second.codeval_id).first.try(:code).to_s + '"' + ","
              file += inform.studies.second.factor.to_s + ","
            else
              file += '"",,'
            end
            if inform.studies.third != nil
              file += '"' + Codeval.where(id: inform.studies.third.codeval_id).first.try(:code).to_s + '"' + ","
              file += inform.studies.third.factor.to_s + ","
            else
              file += '"",,'
            end
          end


          file += inform.cost.to_s + ","

          if params[:inf_type] != 'cito'
            # file += ','#DESCR
            # file += ','#DIAGNOSTIC
            file += '"' + inform.diagnostics.first.try(:pss_code).to_s + '"' + ","

            if inform.diagnostics.second != nil
              file += '"' + inform.diagnostics.second.try(:pss_code).to_s + '"' + ","
            else
              file += '"",'
            end
            if inform.diagnostics.third != nil
              file += '"' + inform.diagnostics.third.try(:pss_code).to_s + '"' + ","
            else
              file += '"",'
            end
            if inform.diagnostics.fourth != nil
              file += '"' + inform.diagnostics.fourth.try(:pss_code).to_s + '"' + ","
            else
              file += '"",'
            end
            if inform.diagnostics.fifth != nil
              file += '"' + inform.diagnostics.fifth.try(:pss_code).to_s + '"' + ","
            else
              file += '"",'
            end
            if inform.diagnostics[6] != nil
              file += '"' + inform.diagnostics[6].try(:pss_code).to_s + '"' + ","
            else
              file += '"",'
            end

            file += '"050011134601"' + ","
            file += '"' + inform.invoice.to_s + '"' + ","
            file += '"' + inform.prmtr_auth_code.to_s + '"' + ","

            case Promoter.where(id: inform.promoter_id).first.try(:regime).to_s
            when 'Contributivo'
              file += '1,'
            when 'Subsidiado'
              file += '2,'
            when 'Vinculado'
              file += '3,'
            when 'Particular'
              file += '4,'
            when 'Especial'
              file += '1,'
            else
              file += ','
            end

            file += '"",' #OCUPACIÓN que se deja en blanco
            file += '"' + inform.p_municipality.to_s + '"' + ","
            file += '"' + inform.zone_type.to_s + '"' + ","
            file += '"' + inform.pregnancy_status.to_s + '"' + ","
            file += '"' + inform.status.to_s + '"' + ","
            file += '"' + inform.p_cel.to_s + '"' + ","
          end

          if params[:inf_type] != 'cito'
            if inform.physicians.first != nil
              if inform.physicians.first.name != nil
                file += '"' + inform.physicians.first.try(:name).to_s + '"' + ","
              else
                file += '"",'
              end
              if inform.physicians.first.lastname != nil
                file += '"' + inform.physicians.first.try(:lastname).to_s + '"' + ","
              else
                file += '"",'
              end
            else
              file += '"",'
              file += '"",'
            end
          end

          if params[:inf_type] == 'cito'
            file += '"",' #DNOMBRE
            file += '"",' #DAPELLIDO
          end
          

          file += '"' + Branch.where(id: inform.branch_id).first.try(:address).to_s + '"' + ","

          if params[:inf_type] == 'cito'
            file += '"' + inform.p_cel.to_s + '"' + ","
            file += '"' + inform.diagnostics.last.description.to_s + '"' + ","
            file += '"' + inform.micros.last.description.to_s + '"' + ","
            file += '"' + inform.suggestions.last.description.to_s + '"' + ","

            u = User.where(id: inform.cytologist).first
            file += '"' + u.try(:shortname).to_s.upcase + ": #{u.register.to_s}" + '"' + ","

            u = User.where(id: inform.pathologist_id).first
            if inform.diagnostics.count == 1
              file += '"' + "#{u.shortname.upcase}: #{u.register.to_s}" + '"' + ","
            else
              file += '"' + "#{u.shortname.upcase}: #{u.register.to_s}" + '"' + ","
            end

            file += '"",' #CELSUP
            file += '"",' #CELINT
            file += '"",' #CELPARA
            file += '"",' #PLEGA
            file += '"",' #AGRUPA
            file += '"050011134601"' + ","
            file += '"' + inform.invoice.to_s + '"' + ","
            file += '"' + inform.prmtr_auth_code.to_s + '"' + ","

            case Promoter.where(id: inform.promoter_id).first.try(:regime).to_s
            when 'Contributivo'
              file += '1,'
            when 'Subsidiado'
              file += '2,'
            when 'Vinculado'
              file += '3,'
            when 'Particular'
              file += '4,'
            when 'Especial'
              file += '1,'
            else
              file += ','
            end

            file += '"",' #OCUPACIÓN que se deja en blanco
            file += '"' + inform.p_municipality.to_s + '"' + ","
            file += '"' + inform.zone_type.to_s + '"' + ","
            file += '"' + inform.pregnancy_status.to_s + '"' + ","
            file += '"' + inform.status.to_s + '"' + ","
            file += '"' + inform.cytologies.first.pregnancies.to_s + '"' + ","
            file += '"' + inform.cytologies.first.last_mens.to_s + '"' + ","
            file += '"' + inform.cytologies.first.prev_appo.to_s + '"' + ","
            if inform.diagnostics.count == 1
              file += '"' + 95.to_s + '"' + ","  #DIRIMIR CODIGO, 95 cuando patologo no leyo
              file += '"' + inform.diagnostics.first.pss_code.to_s + '"' + ","  #CODCITO
            else
              file += '"' + inform.diagnostics.second.pss_code.to_s + '"' + ","  #CODIGO patologo
              file += '"' + inform.diagnostics.first.pss_code.to_s + '"' + ","  #CODCITO citologo
            end
            # file += '"' + inform.diagnostics.first.pss_code.to_s + '"' + ","  #DIRIMIR CODIGO, 95 cuando patologo no leyo
            # file += '"' + inform.diagnostics.first.pss_code.to_s + '"' + ","  #DIRIMIR CODCITO
            file += '"",'  #VINCULADO
            if inform.administrative_review_id.present?
              file += '"' + User.find(inform.administrative_review_id).initials + '",'
            else
              file += '"",'
            end

            if inform.user_id.present?
              file += '"' + User.find(inform.user_id).initials + '",'
            else
              file += '"",'
            end

            file += inform.created_at.strftime("%d/%m/%Y") + ","  #FECHA1

            if inform.cytologies.first.sample_date != nil
              file += '"' + inform.cytologies.first.sample_date.strftime("%d/%m/%Y") + '"' + ","
            else
              file += '"",'
            end

            file += '"' + inform.cytologies.first.last_result.to_s + '"' + ","
            file += "," #IMPRIMIR que se deja en blanco pero es numérico

            if inform.diagnostics.count == 1
              file += '"' + "DST" + '"' + ","
            else
              if User.where(id: inform.pathologist_review_id).length > 0
                file += '"' + User.find(inform.pathologist_review_id).initials + '"' + ","
              else
                file += '"",'
              end
            end

            if inform.patient.birth_date != nil
              file += inform.patient.birth_date.strftime("%d/%m/%Y") + ',' #FECHANAC
            else
              file += '"",'
            end

            file += '"",' #SINCRONIZA
            file += ',' #FSINCRO
            file += '"' + inform.cytologies.first.birth_control.to_s + '"' + ","

            # file += '"' + Branch.where(id: inform.branch_id).first.try(:initials).to_s + '"' + ","      #ACA VA LA SEDE DONDE SE TOMO LA MUESTRA
            file += ',' #Se reemplazo la de arriba por vacío

            file += '"",' #COLADE
            file += '"",' #COLINAD
            file += '"",' #MONTAINE
            file += '"' + '"' #MONTAINAD
            file += "\r\n"
          end

          if params[:inf_type] != 'cito'

            if inform.blocks.where(stored: true).present?
              file += '"SI"' + ","
            else
              file += '"NO"' + ","
            end

            if inform.pathologist_id.present?
              file += '"' + User.find(inform.pathologist_id).initials.to_s.upcase + '"' + ","
            else
              file += '"",'
            end
            if inform.administrative_review_id.present?
              file += '"' + User.find(inform.administrative_review_id).initials.to_s.upcase + '"' + ","
            else
              file += '"",'
            end


            file += '"",' #TIPO que se deja en blanco
            file += "," #IMPRIMIR que se deja en blanco pero es numérico
            file += '"' + User.where(id: inform.user_id).first.try(:fullname).to_s.upcase + '"' + ","
            file += inform.created_at.strftime("%d/%m/%Y") + ","
            # file += "," #FOTO que se deja en blanco pero es general
            # file += "," #FOTO1 que se deja en blanco pero es general
            # file += "," #FOTO2 que se deja en blanco pero es general
            file += "," #Campo ORDEN que NO esta en la documentacion pero EXISTE


            u = User.where(id: inform.pathologist_id).first
            file += '"' + u.try(:shortname).to_s.upcase + ": #{u.register.to_s}" + '"' + ","
            # file += '"' + User.where(id: inform.pathologist_id).first.try(:fullname).to_s.upcase + '"' + ","


            file += "," #RANGO que se deja en blanco pero es numérico
            file += '"' + inform.diagnostics.first.who_code.to_s + '"' + ","

            if User.where(id: inform.pathologist_review_id).length > 0
              file += '"' + User.find(inform.pathologist_review_id).initials + '"' + ","
            else
              file += '"",'
            end
            # file += '"' + User.where(id: inform.pathologist_review_id).first.first_name[0] + User.where(id: inform.pathologist_id).first.last_name[0] + '"' + ","

            if inform.p_age_type == nil
              file += '"",'
            elsif inform.p_age_type == "A"
              file += '"AÑOS",'
            elsif inform.p_age_type == "M"
              file += '"MESES",'
            elsif inform.p_age_type == "D"
              file += '"DÍAS",'
            end
            file += ',' #COPAGOENTIDAD a partir de aca es
            file += ',' #COPAGO
            file += "\r\n"
          end

        end

        if params[:inf_type] == 'clin'
          # filename = "CLH.zip"
          zipfile.get_output_stream("clh.TXT") { |f| f.puts(file[0..-3]) }
        elsif params[:inf_type] == 'hosp'
          # filename = "HOH.zip"
          zipfile.get_output_stream("hoh.TXT") { |f| f.puts(file[0..-3]) }
        elsif params[:inf_type] == 'cito'
          # filename = "KCIT1.zip"
          zipfile.get_output_stream("kcit1.TXT") { |f| f.puts(file[0..-3]) }
        elsif params[:inf_type] == 'cito2'
          # filename = "KCIT2.zip"
          zipfile.get_output_stream("kcit2.TXT") { |f| f.puts(file[0..-3]) }
        end


      end
      @file2 = File.open("temp_file.zip")
      zip_data = File.read("temp_file.zip")
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    ensure
      File.delete(@file2)
    end
  end

  def descr_micros
    @tab = :pathologist

    serializer = %w[id tag_code pathologist_id inf_status receive_date patient_id]

    if role_admin_allowed?
      @informs = Inform.select(serializer).where(inf_status: nil).where.not(pathologist_id: nil).or(Inform.select(serializer).where(inf_status: "revision_cyto")).order(:consecutive).paginate(page: params[:page], per_page: 60)
    else
      @informs = Inform.select(serializer).where(inf_status: nil, pathologist_id: current_user.id).or(Inform.select(serializer).where(inf_status: "revision_cyto", pathologist_id: current_user.id)).order(:consecutive).paginate(page: params[:page], per_page: 60)
    end

  end

  def role_admin_allowed?
    actual_role = Role.where(id: current_user.role_id).first.name
    if actual_role == "Secretaria" || actual_role == "Jefatura de laboratorio" || actual_role == "CTO"
      return true
    else
      return false
    end
  end

  def descr_micros_cyto
    @tab = :cytologist
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: nil, cytologist: current_user.id)
    # else
    #   @informs = Inform.where(inf_status: nil, cytologist: current_user.id)
    # end

    # if params[:init_date]
    #   initial_date = Date.parse(params[:init_date]).beginning_of_day
    #   final_date = Date.parse(params[:final_date]).end_of_day
    #   date_range = initial_date..final_date
    # else
    #   initial_date = 1.day.ago.beginning_of_day
    #   final_date = Time.now.end_of_day
    #   date_range = initial_date..final_date
    # end

    serializer = %w[id tag_code pathologist_id inf_status receive_date patient_id cytologist]

    if role_admin_allowed?
      # @informs = Inform.unscoped.where(user_review_date: date_range, inf_type: "cito", inf_status: nil).order(pathologist_id: :asc)
      @informs = Inform.select(serializer).unscoped.where(inf_type: "cito", inf_status: nil).where.not(cytologist: nil).order(:consecutive).paginate(page: params[:page], per_page: 10)
    else
      # @informs = Inform.where(receive_date: date_range, inf_type: "cito", inf_status: nil, cytologist: current_user.id)
      @informs = Inform.select(serializer).where(inf_type: "cito", inf_status: nil, cytologist: current_user.id).order(:consecutive).paginate(page: params[:page], per_page: 10)
    end
  end

  def descr_micro
    @organs = Organ.all

    @automatics = []
    # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
    Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
      if @inform.inf_type == "cito"
        Automatic.where(auto_type: "cito", organ: sample.organ_code).each do |auto|
          if auto.scripts.first.pss_code.present?
            pss_code = auto.scripts.first.pss_code.to_i
            if pss_code < 10
              auto.title = '0' + auto.scripts.first.pss_code + ". " + auto.title if auto.scripts.present?
            else
              auto.title = auto.scripts.first.pss_code + ". " + auto.title if auto.scripts.present?
            end
          end
          
          @automatics << auto
        end
      else
        Automatic.where(auto_type: "micro", organ: sample.organ_code).order(:title).each do |auto|
          @automatics << auto
        end
      end
    end

    if @inform.inf_type == 'cito'
      @automatics = @automatics.sort_by {|auto| auto[:title] }
    end

    @automatics

    # @samples = @inform.samples

    # @samplesc = @inform.samples.where(name: "Cassette")

    # @blocks = @inform.blocks
  end

  def edit_micro

  end

  def set_revision
    if @inform.inf_type == 'cito'
      if @inform.pathologist_id == nil && @inform.cytologist != nil
        # @inform.update(user_id: current_user.id, user_review_date: Time.zone.now.to_date, inf_status: "revision_cyto")
        @inform.update(user_review_date: Time.zone.now.to_date, inf_status: "revision_cyto")
        redirect_to descr_micros_cyto_informs_path
      end
      if @inform.pathologist_id != nil
        # @inform.update(user_id: current_user.id, user_review_date: Time.zone.now.to_date, inf_status: "revision")
        @inform.update(user_review_date: Time.zone.now.to_date, inf_status: "revision")
        redirect_to descr_micros_informs_path
      end
    else
      # @inform.update(user_id: current_user.id, user_review_date: Time.zone.now.to_date, inf_status: "revision")
      @inform.update(user_review_date: Time.zone.now.to_date, inf_status: "revision")
      redirect_to descr_micros_informs_path
    end
  end

  def clear_revision
    @inform.update(inf_status: nil, pathologist_review_id: nil, administrative_review_id: nil)

    redirect_to descr_micro_inform_path(@inform)
  end

  def set_ready
    if Role.where(id: current_user.role_id).first.name == "Patologia" || Role.where(id: current_user.role_id).first.name == "CTO"
      # administrative_standard_review_id = User.where(email: "administracion@patologiasuescun.com").first.id
      @inform.update(pathologist_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)
    elsif Role.where(id: current_user.role_id).first.name == "Secretaria" || Role.where(id: current_user.role_id).first.name == "Jefatura de laboratorio"
      if @inform.inf_type != 'cito'
        if @inform.pathologist_review_id == nil
          @inform.update(pathologist_review_id: @inform.pathologist_id, administrative_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)
          @inform.comments.create(user_id: current_user.id, title: "revision", body: "Revisión científica asignada automáticamente al mismo patógolo por administrativo, al encontrarse sin revisar por usuario de patología")
        else
          @inform.update(administrative_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)
        end
      else
        if @inform.pathologist_id == nil  #Si nungún patólogo estuvo asignado, debe quedar DST
          pathologist_standard_id = User.where(email: "gerencia@patologiasuescun.com").first.id
          @inform.update(pathologist_id: pathologist_standard_id, pathologist_review_id: pathologist_standard_id, administrative_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)
        else
          @inform.update(pathologist_review_id: @inform.pathologist_id, administrative_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)  #En este caso, pathologist_id podría ser nil si la cito era negativa, o podría tener datos si tuvo que ser validada por patologia
        end

      end
    end
    if index_revision_next
      redirect_to show_revision_inform_path(index_revision_next)
    else
      redirect_to index_revision_informs_path
    end
  end

  def distribution
    @tab = :asign

    @informs = []
    @informs_unassigned = []
    @informs_rest = []

    Inform.by_tagcode.biop.not_ready.order(:consecutive).each do |inform|
      @informs << inform if inform.slides_ok? && inform.path_assigned?
      @informs_unassigned << inform if inform.slides_ok? && !inform.path_assigned?
    end

    @informs = @informs.sort{ |inform| inform[:consecutive] }
    @informs_unassigned = @informs_unassigned.sort{ |inform| inform[:consecutive] }

    pathologist_role_id = Role.find_by_name("Patologia").id
    @users = User.where(role_id: pathologist_role_id)
  end

  def distribution_pat_cyto
    @tab = :asign

    @informs2 = []
    @informs2_unassigned = []
    @informs2_rest = []

    Inform.by_tagcode.cyto.not_ready_or_cyto.each do |inform|
      @informs2 << inform if inform.slides_ok? && inform.path_assigned?
      @informs2_unassigned << inform if inform.slides_ok? && !inform.path_assigned?
    end

    @informs2_first_batch = @informs2_unassigned[0..49]
    @informs2_rest = @informs2_unassigned[50..-1] if @informs2_unassigned[50..-1].present?

    @already_negative = 0

    @informs2.each do |inform|
      if inform.diagnostics.first&.result.present?
        @already_negative += 1 if inform.cyto_neg? && inform.path_assigned?
      end
    end

    @negative_cytos = []
    @informs3_unassigned = []   #Aca solo almaceno las positivas e instatisfactorias. No las saco del arreglo original para no lidiar con offsets
    if @informs2_unassigned.present?
      @informs2_unassigned.each do |inform|
        if inform.diagnostics.first&.result.present?
          @informs3_unassigned << inform if inform.cyto_pos_ins?
          if inform.cyto_neg?
            if inform.path_assigned?
              @informs2 << inform
              @already_negative = @already_negative + 1
            else
              @negative_cytos << inform
            end
          end
        end
      end
      # proportion = 0.1
      # negative_pick = (@negative_cytos.count * proportion).ceil  #Obtengo el 10% round up de las negativas

      # if @already_negative < negative_pick
      #   negative_pick.times do
      #     n = rand(1..@negative_cytos.length) - 1
      #     while @informs.last == @negative_cytos[n]
      #       n = rand(1..@negative_cytos.length) - 1 #No es posible repetir numero
      #     end
      #     @informs3_unassigned << @negative_cytos[n]
      #     @negative_cytos.delete_at(n)
      #   end
      # end
      # if @already_negative >= negative_pick
      #   if @negative_cytos.present?
      #     @negative_cytos.each do |inform|
      #       inform.update(inf_status: "revision", user_review_date: Time.zone.now.to_date) #Se deben marcar como para validación
      #     end
      #   end
      # end
    end

    @informs2_first_batch = @informs3_unassigned[0..49]
    @informs_unassigned = [] if @informs2_first_batch.blank?

    @informs2_rest = @informs3_unassigned[50..-1]
    @informs2_rest = [] if @informs2_rest.blank?
      
    pathologist_role_id = Role.find_by_name("Patologia").id
    @users = User.where(role_id: pathologist_role_id)
  end

  def distribution_cyto
    @informs = []
    @informs_unassigned = []
    @informs_rest = []

    Inform.by_tagcode.cyto.not_ready.each do |inform|
      @informs << inform if inform.slides_ok? && inform.cyto_assigned?
      @informs_unassigned << inform if inform.slides_ok? && !inform.cyto_assigned?
    end

    @informs_first_batch = @informs_unassigned[0..49]
    @informs_rest = @informs_unassigned[50..-1] if @informs_unassigned[50..-1].present?

    cytologist_role_id = Role.where(name: "Citologia").first.id
    @users = User.where(role_id: cytologist_role_id)
  end

  def assign
    Inform.where(id: params[:inform_ids]).update_all({pathologist_id: params[:pathologist_id].to_i == 0 ? nil : params[:pathologist_id].to_i, user_review_date: Time.zone.now.to_date })

    redirect_to distribution_path
  end

  def assign_pat_cyto
    #En este proceso se asigna patólogo/a a lo que este chuleado
    Inform.where(id: params[:inform_ids]).update_all({pathologist_id: params[:pathologist_id].to_i == 0 ? nil : params[:pathologist_id].to_i, user_review_date: Time.zone.now.to_date })

    #Y en este, todo lo que no esté chuleado y sea negativa (sin asignar) se pasa a "revision"
    @informs2_unassigned = []
    Inform.by_tagcode.cyto.not_ready_or_cyto.each do |inform|
      @informs2_unassigned << inform if inform.slides_ok? && !inform.path_assigned?
    end

    if @informs2_unassigned.present?
      @informs2_unassigned.each do |inform|
        if inform.diagnostics.first&.result.present?
          if inform.cyto_neg?
            unless inform.path_assigned?
              inform.update(inf_status: "revision", user_review_date: Time.zone.now.to_date)
            end
          end
        end
      end
    end

    redirect_to distribution_pat_cyto_path
  end

  def assign_cyto
    Inform.where(id: params[:inform_ids]).update_all({cytologist: params[:cytologist].to_i == 0 ? nil : params[:cytologist].to_i })

    redirect_to distribution_cyto_path
  end

  # GET /informs/1
  # GET /informs/1.json
  def show
    @organs = Organ.all

    @automatics = Automatic.all
    @automatics_macro = Automatic.where(auto_type: "macro")
    @automatics_micro = Automatic.where(auto_type: "micro")


    @samples = @inform.samples

    @samplesc = @inform.samples.where(name: "Cassette")

    @blocks = @inform.blocks

    @all_cups_price = 0
    @inform.studies.each do |study|
      @all_cups_price += study.price * study.factor
    end

    if @inform.inf_type == 'cito'
      @cytologies = @inform.cytologies
    end
  end

  def switch_patient
    @patient = Patient.where(id_number: params[:new_id]).first
    @inform = Inform.find(params[:id])
    old_patient_id_number = @inform.patient.id_number
    if @patient != nil
      if @patient.birth_date != nil
        @inform.update(patient_id: @patient.id, p_age: get_age(@patient.birth_date)[0], p_age_type: get_age(@patient.birth_date)[1])
      else
        @inform.update(patient_id: @patient.id)
      end
      objection = @inform.objections.build(
          user_id: current_user.id,
          obcode_id: params[:obcode_id],
          responsible_user_id: @inform.user_id,
          description: "Se hace cambio de paciente en: " + Time.now.to_s + ". Id anterior: " + old_patient_id_number + ". Nuevo Id: " + @patient.id_number + "."

        )
      objection.save
      redirect_to @inform, notice: "Informe exitosamente asignado a paciente!"
    else
      redirect_to @inform, alert: "Número de identificación no encontrado!"
    end
  end

  def get_age(date)
    if date == nil
      return ["", ""]
    else
      days = Time.zone.now.to_date - date
      if days >= 365
        return [ (days / 365).to_i, "A"]
      end
      if days >= 30
        return [ (days / 30).to_i, "M"]
      end
      return [ days.to_i, "D"]
    end
  end

  def autos_micro
    @organs = Organ.all

    @automatics = []
    # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
    Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
      Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
        @automatics << auto
      end
    end
  end

  # GET /informs/new
  def new
    @inform = Inform.new
    @physician = @inform.physicians.build
  end

  # GET /informs/1/edit
  def edit
    @promoters = Promoter.where(enabled: true)
    @promoters.each do |promoter|
      promoter.initials = promoter.regime[0] + "-" + promoter.initials
    end
    @promoters = @promoters.pluck(:initials, :id)

    @municipalities = Municipality.all
    @municipalities.each do |municipality|
      municipality.municipality = municipality.municipality + " - " + municipality.department[0..2]
    end
  end

  def create
    inform = Inform.new(inform_params)
    inform.patient_id = params[:inform][:patient_id]
    # inform = @patient.informs.build(inform_params)
    inform.user_id = current_user.id


    entity = Branch.where(id: inform.branch_id).first.entity
    if entity == nil
      inform.entity_id = nil
    else
      inform.entity_id = entity.id
    end

    inform.regime = Promoter.where(id: inform.promoter_id).first.try(:regime)

    date_range = Time.zone.now.to_date.beginning_of_year..Time.zone.now.to_date.end_of_year

    if params[:inform][:inf_type] == "clin"
      adjust = 0
      adjust = Oldrecord.where(clave: 'C', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
       consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1 + adjust
       inform.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
       inform.consecutive = consecutive.to_i
    else
      if params[:inform][:inf_type] == "hosp"
        adjust = 0
        adjust = Oldrecord.where(clave: 'H', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
        consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1 + adjust
        inform.tag_code = "H" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
        inform.consecutive = consecutive.to_i
    else
      adjust = 0
      adjust = Oldcito.where(clave: 'K', fecha1: date_range).count if Time.current.strftime('%Y') == '2021'
      consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1 + adjust
      inform.tag_code = "K" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
      inform.consecutive = consecutive.to_i
     end
    end

    inform.save

    if inform.inf_type == "cito"
      #Se crea el recipiente
      @recipient = inform.recipients.build
      @recipient.tag = generate_rec_tag(inform)
      @recipient.user_id = current_user.id
      @recipient.description = ""
      @recipient.save

      #Se crea el extendido
      @sample = inform.samples.build
      @sample.user_id = current_user.id
      @sample.name = "Extendido"
      @sample.included = false
      @sample.recipient_tag = @recipient.tag
      @sample.sample_tag = generate_letter_tag(inform)
      @sample.organ_code = "Vagina"
      @sample.description = ""
      @sample.fragment = 1
      @sample.save

      #Se crea el CUP
      branch = Branch.find(inform.branch_id)
      entity = branch.entity
      cost = Value.where(codeval_id: Codeval.where(code: "898001").first.id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.value

      price =  Factor.where(codeval_id: Codeval.where(code: "898001").first.id, rate_id: branch.entity.rate_id).first.price
      margin =  price - cost

      cost_description = Cost.where(id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:name)
      value_description = Value.where(codeval_id: Codeval.where(code: "898001").first.id, cost_id: Rate.where(id: branch.entity.rate_id).first.cost_id).first.try(:description)
      rate_description = Rate.where(id: branch.entity.rate_id).first.try(:name)
      factor_description = Factor.where(codeval_id: Codeval.where(code: "898001").first.id, rate_id: branch.entity.rate_id).first.try(:description)

      price_description = cost_description + ". " + rate_description + ". Notas costo: " + value_description + ". Notas factor: " + factor_description

      @study = inform.studies.build(
        user_id: current_user.id,
        codeval_id: Codeval.where(code: "898001").first.id,
        factor: 1,
        cost: cost,
        price: price,
        margin: margin,
        price_description: price_description
        )
      @study.save

      #Se crea el slide
      inform.slides.create(slide_tag: @sample.sample_tag, user_id: current_user.id) #Se crea un slide con el mismo tag de la sample
      @sample.update(slide_tag: @sample.sample_tag)  #Se guarda el tag creado en la sample para que queden asociados
    end
      # redirect_to inform, notice: 'Informe exitosamente creado.'
    redirect_to patients_path + "?inf_type=" + params[:inform][:inf_type]
  end

  # PATCH/PUT /informs/1
  # PATCH/PUT /informs/1.json
  def update
    # @inform.branch_id = inform_params[:branch_id]
    # @inform.entity_id = Branch.find(inform_params[:branch_id]).entity.id
    # @inform.save
    @inform.update(inform_params)
    @inform.update(entity_id: Branch.find(inform_params[:branch_id]).entity.id)

    if @inform.inf_status == "revision"
      redirect_to show_revision_inform_path(@inform), notice: 'Informe exitosamente actualizado.'
    else
      redirect_to @inform, notice: 'Informe exitosamente actualizado.'
    end

  end

  # DELETE /informs/1
  # DELETE /informs/1.json
  def destroy
    @inform.destroy
    respond_to do |format|
      format.html { redirect_to informs_url, notice: 'Informe exitosamente borrado.' }
      format.json { head :no_content }
    end
  end

  def anulate
    if @inform.inf_status == "anulado"
      @inform.update(inf_status: nil, user_id: current_user.id)
      objection = @inform.objections.build(
          user_id: current_user.id,
          obcode_id: 22,
          responsible_user_id: @inform.user_id,
          description: "Se restaura informe. Fecha: " + DateTime.now.to_s

        )
    else
      @inform.update(inf_status: "anulado", user_id: current_user.id)
      objection = @inform.objections.build(
          user_id: current_user.id,
          obcode_id: 22,
          responsible_user_id: @inform.user_id,
          description: "Se anula informe. Fecha: " + DateTime.now.to_s

        )
    end
    objection.save

    redirect_to informs_url, notice: 'Informe exitosamente anulado.'
  end

  def preview
    @samples = @inform.samples.select(:fragment, :sample_tag, :description, :name)
    p_role = Role.where(name: "Patologia").first.id
    if @inform.inf_type != 'cito'
      @pathologists = []

      if @inform.pathologist_id != nil
        @pathologists << User.find(@inform.pathologist_id)
      else
        @pathologists = []
      end


      @micro_text = ""
      @inform.micros.each do |micro|
        if User.find(micro.user_id).role_id == p_role
          @pathologists << User.find(micro.user_id)
        end
        if micro.description.size > 500
          @micro_text = @micro_text + "\n\r" + "\n\r" + micro.description + "\n\r "
        else
          @micro_text = @micro_text + micro.description + " "
        end

      end

      @diagnostic_text = ""
      @inform.diagnostics.each do |diagnostic|
        if User.find(diagnostic.user_id).role_id == p_role
          @pathologists << User.find(diagnostic.user_id)
        end
        @diagnostic_text = @diagnostic_text + diagnostic.description + " "
      end
      @diagnostic_codes = @inform.diagnostics.pluck(:pss_code, :who_code).uniq

      @pathologists = @pathologists.uniq

    else
      @pathologists = []

      if @inform.pathologist_id != nil
        @pathologists << User.find(@inform.pathologist_id)
      end

      if @inform.diagnostics != []
        diagnostic = @inform.diagnostics.last
        if User.find(diagnostic.user_id).role_id == p_role
          @pathologists << User.find(diagnostic.user_id)
        end
      end
      @pathologists = @pathologists.uniq

      @cytologist = User.where(id: @inform.cytologist).first

      if @inform.cytologies != []
        @cytology = @inform.cytologies.first
      else
        @cytology = nil
      end
    end
    if @inform.inf_type == 'hosp'
      if @inform.p_address.present?
        @delivery_address = @inform.p_address
      else
        @delivery_address = Branch.where(id: @inform.branch_id).first.try(:name)
      end
    end
    
    @delivery_address = Branch.where(id: @inform.branch_id).first.try(:address) if @inform.inf_type != 'hosp'
  end

  # private
    def get_nomen(str)
      return str.split('-',2)[1].split('-',2)[1]
    end

    def generate_rec_tag(inform)
      next_number = 1
      answer = false
      if inform.recipients.empty?
        return inform.tag_code + '-R1'
      end

      inform.recipients.length.times {
        inform.recipients.each do |rec|
          if (rec.tag == inform.tag_code + '-R' + next_number.to_s)
            next_number = next_number + 1
            break
          end
        end
      }

      return inform.tag_code + '-R' + next_number.to_s
    end

    def generate_number_tag(sample)
      if sample.sample_tag[-1] =~ /[A-Z]/
        # sample.update(sample_tag: sample.sample_tag + '1')
        return sample.sample_tag + '2'
      end
      if sample.sample_tag[-1] =~ /[0-9]/
        return sample.sample_tag[0..-2] + (sample.sample_tag[-1].to_i + 1).to_s
      end
    end

    def generate_letter_tag(inform)
      next_letter = 'A'
      answer = false
      if inform.samples.empty?
        return inform.tag_code + '-A'
      end

      inform.samples.length.times {
        inform.samples.each do |sample|
          if (sample.sample_tag == inform.tag_code + '-' + next_letter) || (sample.sample_tag == inform.tag_code + '-' + next_letter + '1')
            next_letter = (next_letter.ord + 1).chr
            break
          end
        end
      }

      return inform.tag_code + '-' + next_letter
    end

    def clasify_templates

    end
    # Use callbacks to share common setup or constraints between actions.
    def set_inform
      @inform = Inform.find(params[:id])
    end

    private

    def index_revision_next
      if role_admin_allowed?
        @informs = Inform.unscoped.where(inf_status: "revision").order(inf_type: :asc, consecutive: :asc)
      else
        @informs = Inform.unscoped.where(inf_status: "revision", pathologist_id: current_user.id).order(inf_type: :asc, consecutive: :asc)
      end

      @informs.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inform_params
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, :p_age, :p_age_type, :p_address, :p_email, :p_tel, :p_cel, :p_occupation, :p_residence_code, :p_municipality, :p_department, :inf_type, :cytologist, cytologies_attributes: [:id, :inform_id, :pregnancies, :last_mens, :prev_appo, :sample_date, :last_result, :birth_control, :user_id, :suggestion, :neck_aspect, :hysterectomy], physicians_attributes: [:id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] )
    end
end
