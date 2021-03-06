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
      @informs = Inform.where(tag_code: params[:tag_code]).paginate(page: params[:page], per_page: 10)
    else
      @informs = Inform.where(receive_date: date_range, inf_type: params[:inf_type]).paginate(page: params[:page], per_page: 10)
    end
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

    @oldrecords = Oldrecord.where(fecharec: date_range, clave: params[:inf_type] == 'clin' ? "C" : params[:inf_type] == 'hosp' ? "H" : "K").paginate(page: params[:page], per_page: 10)
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
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: "revision")
    # else
    #   @informs = Inform.where(inf_status: "revision")
    # end
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.unscoped.where(user_review_date: date_range, inf_status: "revision").order(pathologist_id: :asc, cytologist: :asc).paginate(page: params[:page], per_page: 10)
  end

  def index_ready
    @tab = :ready
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: "ready")
    # else
    #   @informs = Inform.where(inf_status: "ready")
    # end
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @informs = Inform.where(delivery_date: date_range, inf_status: "ready")
  end

  def publish
    Inform.where(id: params[:inform_ids]).update_all({inf_status: "published", delivery_date: Time.now})
    if params[:init_date]
      redirect_to informs_index_published_path + "?init_date=#{params[:init_date]}&final_date=#{params[:final_date]}"
    else
      redirect_to informs_index_published_path
    end
  end

  def index_published
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
    @informs = Inform.where(delivery_date: date_range, inf_status: "published").or(Inform.where(delivery_date: date_range, inf_status: "downloaded")).paginate(page: params[:page], per_page: 10)
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
    informs = Inform.where(inf_type: params[:inf_type], inf_status: "published", delivery_date: date_range).or(Inform.where(inf_type: params[:inf_type], inf_status: "downloaded", delivery_date: date_range))

    file = ""
    file_name = 1
    filename = "exp_fox_" + params[:inf_type] + "_" + params[:init_date] + "_a_" + params[:final_date] + ".zip"
    begin
      Zip::File.open("temp_file.zip", Zip::File::CREATE) do |zipfile|

        informs.each_with_index do |inform, idx|

          descr = ""
          inform.recipients.each_with_index do |recipient, n|
            descr += "Contenido de recipiente \##{n + 1}:" + "\r\n" + recipient.description + "\r\n" + "Bloqueado de la siguiente manera:\r\n\r\n"
            inform.samples.where(recipient_tag: recipient.tag).each do |sample|
              if sample.name == "Cassette"
                descr += sample.description
                descr += ": " if sample.description != ""
                descr += sample.fragment.to_s + "F-" + get_nomen(sample.sample_tag) + "\r\n"
              else
                descr += sample.description + "-" + get_nomen(sample.sample_tag) + "\r\n"
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


          file += '"' + inform.tag_code[0] + '"' + ","
          file += inform.tag_code[4..-1] + ","
          file += inform.receive_date.strftime("%d/%m/%Y") + ","
          file += inform.delivery_date.strftime("%d/%m/%Y") + ","
          file += '"' + inform.patient.lastname1.upcase + '"' + ","
          file += '"' + inform.patient.lastname2.upcase + '"' + ","
          file += '"' + inform.patient.name1.upcase + '"' + ","
          file += '"' + inform.patient.name2.upcase + '"' + ","
          file += '"' + inform.patient.id_type + '"' + ","
          file += '"' + inform.patient.id_number + '"' + ","
          file += '"' + '"' + "," #Historia, se supone que ese campo ya no se usa
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


          file += '"' + inform.patient.sex + '"' + ","
          file += '"' + Entity.where(id: inform.entity_id).first.try(:initials) + '"' + ","
          file += '"' + Promoter.where(id: inform.promoter_id).first.try(:initials) + '"' + ","
          file += '"' + Promoter.where(id: inform.promoter_id).first.try(:code) + '"' + ","

          file += '"' + Codeval.where(id: inform.studies.first.codeval_id).first.try(:code) + '"' + ","
          file += inform.studies.first.factor.to_s + ","

          if inform.studies.second != nil
            file += '"' + Codeval.where(id: inform.studies.second.codeval_id).first.try(:code)+ '"' + ","
            file += inform.studies.second.factor.to_s + ","
          else
            file += '"",,'
          end
          if inform.studies.third != nil
            file += '"' + Codeval.where(id: inform.studies.third.codeval_id).first.try(:code) + '"' + ","
            file += inform.studies.third.factor.to_s + ","
          else
            file += '"",,'
          end

          file += inform.cost.to_s + ","
          # file += ','#DESCR
          # file += ','#DIAGNOSTIC
          file += '"' + inform.diagnostics.first.pss_code + '"' + ","

          if inform.diagnostics.second != nil
            file += '"' + inform.diagnostics.second.pss_code + '"' + ","
          else
            file += '"' + '"' + ","
          end
          if inform.diagnostics.third != nil
            file += '"' + inform.diagnostics.third.pss_code + '"' + ","
          else
            file += '"' + '"' + ","
          end
          if inform.diagnostics.fourth != nil
            file += '"' + inform.diagnostics.fourth.pss_code + '"' + ","
          else
            file += '"' + '"' + ","
          end
          if inform.diagnostics.fifth != nil
            file += '"' + inform.diagnostics.fifth.pss_code + '"' + ","
          else
            file += '"' + '"' + ","
          end
          if inform.diagnostics[6] != nil
            file += '"' + inform.diagnostics[6].pss_code + '"' + ","
          else
            file += '"' + '"' + ","
          end

          file += '"050011134601"' + ","
          file += '"' + inform.invoice + '"' + ","
          file += '"' + inform.prmtr_auth_code + '"' + ","
          file += '"' + Promoter.where(id: inform.promoter_id).first.try(:regime) + '"' + ","
          file += '"' + '"' + "," #OCUPACIÓN que se deja en blanco
          file += '"' + inform.p_municipality + '"' + ","
          file += '"' + inform.zone_type + '"' + ","
          file += '"' + inform.pregnancy_status + '"' + ","
          file += '"' + inform.status + '"' + ","
          file += '"' + inform.p_tel.to_s + "-" + '"' + ","
          if inform.physicians.first != nil
            if inform.physicians.first.name != nil
              file += '"' + inform.physicians.first.name + '"' + ","
            else
              file += '"' + '"' + ","
            end
            if inform.physicians.first.lastname != nil
              file += '"' + inform.physicians.first.lastname + '"' + ","
            else
              file += '"' + '"' + ","
            end
          else
            file += '"' + '"' + ","
            file += '"' + '"' + ","
          end


          file += '"' + Branch.where(id: inform.branch_id).first.try(:address) + '"' + ","
          file += '"' + inform.blocks.where(stored: true).first.try(:block_tag).to_s + '"' + ","
          file += '"' + User.where(id: inform.pathologist_id).first.fullname.upcase + '"' + ","
          file += '"' + User.where(id: inform.administrative_review_id).first.try(:first_name).to_s.upcase + " " + User.where(id: inform.administrative_review_id).first.try(:last_name).to_s.upcase + '"' + ","
          file += '"' + '"' + "," #TIPO que se deja en blanco
          file += "," #IMPRIMIR que se deja en blanco pero es numérico
          file += '"' + User.where(id: inform.user_id).first.fullname.upcase + '"' + ","
          file += inform.created_at.strftime("%d/%m/%Y") + ","
          # file += "," #FOTO que se deja en blanco pero es general
          # file += "," #FOTO1 que se deja en blanco pero es general
          # file += "," #FOTO2 que se deja en blanco pero es general
          file += "," #Campo ORDEN que NO esta en la documentacion pero EXISTE
          file += '"' + User.where(id: inform.pathologist_id).first.first_name + User.where(id: inform.pathologist_id).first.last_name + '"' + ","
          file += "," #RANGO que se deja en blanco pero es numérico
          file += '"' + inform.diagnostics.first.who_code.to_s + '"' + ","
          file += '"' + User.where(id: inform.pathologist_review_id).first.first_name[0] + User.where(id: inform.pathologist_id).first.last_name[0] + '"' + ","
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
        zipfile.get_output_stream("informes.TXT") { |f| f.puts(file[0..-3]) }
      end
      file = File.open("temp_file.zip")
      zip_data = File.read("temp_file.zip")
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    ensure
      File.delete(file)
    end
  end

  def descr_micros
    @tab = :pathologist
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   @informs = Inform.where(receive_date: date_range, inf_status: nil, pathologist_id: current_user.id).or(Inform.where(receive_date: date_range, inf_status: "revision_cyto", pathologist_id: current_user.id))
    # else
    #   @informs = Inform.where(inf_status: nil, pathologist_id: current_user.id).or(Inform.where(inf_status: "revision_cyto", pathologist_id: current_user.id))
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    if role_admin_allowed?
      @informs = Inform.unscoped.where(user_review_date: date_range, inf_status: nil).or(Inform.unscoped.where(user_review_date: date_range, inf_status: "revision_cyto")).order(pathologist_id: :asc)
    else
      @informs = Inform.where(user_review_date: date_range, inf_status: nil, pathologist_id: current_user.id).or(Inform.where(user_review_date: date_range, inf_status: "revision_cyto", pathologist_id: current_user.id))
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

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    if role_admin_allowed?
      @informs = Inform.unscoped.where(user_review_date: date_range, inf_type: "cito", inf_status: nil).order(pathologist_id: :asc)
    else
      @informs = Inform.where(receive_date: date_range, inf_type: "cito", inf_status: nil, cytologist: current_user.id)
    end
  end

  def descr_micro
    @organs = Organ.all

    @automatics = []
    # @inform.samples.unscoped.select(:organ_code).distinct.each do |sample|
    Sample.unscoped.where(inform_id: @inform.id).select(:organ_code).distinct.each do |sample|
      if @inform.inf_type == "cito"
        Automatic.where(auto_type: "cito", organ: sample.organ_code).each do |auto|
          @automatics << auto
        end
      else
        Automatic.where(auto_type: "micro", organ: sample.organ_code).each do |auto|
          @automatics << auto
        end
      end
    end

    # @samples = @inform.samples

    # @samplesc = @inform.samples.where(name: "Cassette")

    # @blocks = @inform.blocks
  end

  def edit_micro

  end

  def set_revision
    if @inform.inf_type == 'cito'
      if @inform.pathologist_id == nil && @inform.cytologist != nil
        @inform.update(user_id: current_user.id, user_review_date: Time.zone.now.to_date, inf_status: "revision_cyto")
        redirect_to descr_micros_cyto_informs_path
      end
      if @inform.pathologist_id != nil
        @inform.update(user_id: current_user.id, user_review_date: Time.zone.now.to_date, inf_status: "revision")
        redirect_to descr_micros_informs_path
      end
    else
      @inform.update(user_id: current_user.id, user_review_date: Time.zone.now.to_date, inf_status: "revision")
      redirect_to descr_micros_informs_path
    end
  end

  def clear_revision
    @inform.update(inf_status: nil, pathologist_review_id: nil, administrative_review_id: nil)

    redirect_to descr_micro_inform_path(@inform)
  end

  def set_ready
    if Role.where(id: current_user.role_id).first.name == "Patologia" || Role.where(id: current_user.role_id).first.name == "CTO"
      @inform.update(pathologist_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)
    elsif Role.where(id: current_user.role_id).first.name == "Secretaria" || Role.where(id: current_user.role_id).first.name == "Jefatura de laboratorio"
      @inform.update(administrative_review_id: current_user.id, inf_status: "ready", delivery_date: Time.now)
    end
    redirect_to index_revision_informs_path
  end

  def distribution
    @tab = :asign
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   # @informs = Inform.where(created_at: date_range).joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    # else
    #   # @informs = Inform.joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true).joins(:inform).select("slides.inform_id").distinct
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    @informs = []
    @informs_unassigned = []
    @informs_first_batch = []
    @informs_rest = []
    @slides.each do |slide|
      if slide.inform.slides.count == slide.inform.slides.where(colored: true, covered: true, tagged: true).count
        if slide.inform.inf_type != 'cito'
          unless slide.inform.inf_status == "ready" || slide.inform.inf_status == "published" || slide.inform.inf_status == "downloaded"
            if slide.inform.pathologist_id != nil
              @informs << slide.inform
            else
              @informs_unassigned << slide.inform
            end
          end
        end
      end
    end


    # Inform.unscoped.where.not(inf_type: "cito").joins(:slides).where(slides: { created_at: Date.parse("01-01-2021")..Date.parse("28-01-2021"), colored: true, covered: true, tagged: true}).select(:tag_code, :id, :pathologist_id, :inf_status).order(pathologist_id: :asc)






    # @informs_unassigned.each_with_index do |inform, n|
    #   if n <=50
    #     @informs_first_batch << inform
    #   else
    #     @informs_rest << inform
    #   end
    # end
    @informs_first_batch = @informs_unassigned[0..49]
    if @informs_first_batch == nil
      @informs_unassigned = []
    end
    @informs_rest = @informs_unassigned[50..-1]
    if @informs_rest == nil
      @informs_rest = []
    end

    @informs2 = []
    @informs2_unassigned = []
    @informs2_first_batch = []
    @informs2_rest = []
    @slides.each do |slide|
      if slide.inform.slides.count == slide.inform.slides.where(colored: true, covered: true, tagged: true).count
        if slide.inform.inf_type == 'cito'
          unless slide.inform.inf_status == "ready" || slide.inform.inf_status == "published" || slide.inform.inf_status == "downloaded" || slide.inform.inf_status == "revision"
            # @informs2 << slide.inform
            if slide.inform.pathologist_id != nil
              @informs2 << slide.inform # citos ya asignadas en otro batch, van directo a @informs porque ya tienen patologo/a
            else
              @informs2_unassigned << slide.inform
            end
          end
        end
      end
    end

    @already_negative = 0

    @informs2.each do |inform|
      if inform.diagnostics != []
        if inform.diagnostics.first.result != nil
          if inform.diagnostics.first.result == 'negativa'
            if inform.pathologist_id != nil
              @already_negative = @already_negative + 1
            end
          end
        end
      end
    end

    @negative_cytos = []
    @informs3_unassigned = []   #Aca solo almaceno las positivas e instatisfactorias. No las saco del arreglo original para no lidiar con offsets
    if @informs2_unassigned != nil
      @informs2_unassigned.each do |inform|
        if inform.diagnostics != []
          if inform.diagnostics.first.result != nil
            if inform.diagnostics.first.result == 'positiva'
              @informs3_unassigned << inform
            end
            if inform.diagnostics.first.result == 'insatisfactoria'
              @informs3_unassigned << inform
            end
            if inform.diagnostics.first.result == 'negativa'
              if inform.pathologist_id != nil
                @informs2 << inform
                @already_negative = @already_negative + 1
              else
                @negative_cytos << inform
              end

            end
          end
        end
      end
      proportion = 0.1
      negative_pick = (@negative_cytos.count * proportion).ceil  #Obtengo el 10% round up de las negativas

      if @already_negative < negative_pick
        negative_pick.times do
          n = rand(1..@negative_cytos.length) - 1
          while @informs.last == @negative_cytos[n]
            n = rand(1..@negative_cytos.length) - 1 #No es posible repetir numero
          end
          @informs3_unassigned << @negative_cytos[n]
          @negative_cytos.delete_at(n)
        end
      end
      if @already_negative == negative_pick
        if @negative_cytos != []
          @negative_cytos.each do |inform|
            inform.update(inf_status: "revision", user_review_date: Time.zone.now.to_date) #Se deben marcar como para validación
          end
        end
      end
    end

    @informs2_first_batch = @informs3_unassigned[0..49]
    if @informs2_first_batch == nil
      @informs_unassigned = []
    end
    @informs2_rest = @informs3_unassigned[50..-1]
    if @informs2_rest == nil
      @informs2_rest = []
    end


    pathologist_role_id = Role.where(name: "Patologia").first.id
    @users = User.where(role_id: pathologist_role_id)

    # @informs_assigned = @informs.where.not(pathologist_id: nil)
    # @informs_unassigned = @informs.where(pathologist_id: nil)
    # @informs_first_batch = @informs_unassigned.limit(50)
    # @informs_rest = @informs_unassigned.offset(50)
  end

  def distribution_cyto
    # if params[:yi]
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date
    #   # @informs = Inform.where(created_at: date_range).joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct
    # else
    #   # @informs = Inform.joins("INNER JOIN slides ON slides.colored = true AND slides.covered = true AND slides.tagged = true").distinct
    #   @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true).joins(:inform).select("slides.inform_id").distinct
    # end
    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end
    @slides = Slide.unscoped.where(colored: true, covered: true, tagged: true, created_at: date_range).joins(:inform).select("slides.inform_id").distinct

    @informs = []
    @informs_unassigned = []
    @informs_first_batch = []
    @informs_rest = []
    @slides.each do |slide|
      if slide.inform.slides.count == slide.inform.slides.where(colored: true, covered: true, tagged: true).count
        if slide.inform.cytologist != nil
          @informs << slide.inform
        else
          @informs_unassigned << slide.inform
        end
      end
      @informs_first_batch = @informs_unassigned[0..49]
      if @informs_first_batch == nil
        @informs_first_batch = []
      end
      @informs_rest = @informs_unassigned[50..-1]
      if @informs_rest == nil
        @informs_rest = []
      end
    end

    cytologist_role_id = Role.where(name: "Citologia").first.id
    @users = User.where(role_id: cytologist_role_id)

    # @informs_assigned = @informs.where.not(cytologist: nil)
    # @informs_unassigned = @informs.where(cytologist: nil)
    # @informs_first_batch = @informs_unassigned.limit(50)
    # @informs_rest = @informs_unassigned.offset(50)
  end

  def assign
    Inform.where(id: params[:inform_ids]).update_all({pathologist_id: params[:pathologist_id].to_i == 0 ? nil : params[:pathologist_id].to_i, user_review_date: Time.zone.now.to_date })

    # if params[:yi] != ""
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date

    #   redirect_to distribution_path + "?di=#{params[:di]}&mi=#{params[:mi]}&yi=#{params[:yi]}&df=#{params[:df]}&mf=#{params[:mf]}&yf=#{params[:yf]}"
    # else
    #   redirect_to distribution_path
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    redirect_to distribution_path + "?init_date=" + params[:init_date] + "&final_date=" + params[:final_date]
  end

  def assign_cyto
    Inform.where(id: params[:inform_ids]).update_all({cytologist: params[:cytologist].to_i == 0 ? nil : params[:cytologist].to_i })

    # if params[:yi] != ""
    #   initial_date = Date.new(params[:yi].to_i, params[:mi].to_i, params[:di].to_i).beginning_of_day
    #   final_date = Date.new(params[:yf].to_i, params[:mf].to_i, params[:df].to_i).end_of_day
    #   date_range = initial_date..final_date

    #   redirect_to distribution_path + "?di=#{params[:di]}&mi=#{params[:mi]}&yi=#{params[:yi]}&df=#{params[:df]}&mf=#{params[:mf]}&yf=#{params[:yf]}"
    # else
    #   redirect_to distribution_cyto_path
    # end

    if params[:init_date]
      initial_date = Date.parse(params[:init_date]).beginning_of_day
      final_date = Date.parse(params[:final_date]).end_of_day
      date_range = initial_date..final_date
    else
      initial_date = 1.day.ago.beginning_of_day
      final_date = Time.now.end_of_day
      date_range = initial_date..final_date
    end

    redirect_to distribution_cyto_path + "?init_date=" + params[:init_date] + "&final_date=" + params[:final_date]
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
       consecutive = Inform.where(inf_type: "clin", created_at: date_range).count + 1
       inform.tag_code = "C" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
    else
     if params[:inform][:inf_type] == "hosp"
       consecutive = Inform.where(inf_type: "hosp", created_at: date_range).count + 1
       inform.tag_code = "H" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
     else
       consecutive = Inform.where(inf_type: "cito", created_at: date_range).count + 1
       inform.tag_code = "K" + Time.zone.now.to_date.strftime('%y').to_s + '-' + consecutive.to_s
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
          @micro_text = @micro_text + "\n" + "\n" + micro.description + "\n "
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def inform_params
      params.require(:inform).permit(:patient_id, :user_id, :physician_id, :tag_code, :receive_date, :delivery_date, :user_review_date, :prmtr_auth_code, :zone_type, :pregnancy_status, :status, :regime, :promoter_id, :entity_id, :branch_id, :copayment, :cost, :price, :invoice, :p_age, :p_age_type, :p_address, :p_email, :p_tel, :p_cel, :p_occupation, :p_residence_code, :p_municipality, :p_department, :inf_type, :cytologist, cytologies_attributes: [:id, :inform_id, :pregnancies, :last_mens, :prev_appo, :sample_date, :last_result, :birth_control, :user_id, :suggestion], physicians_attributes: [:id, :inform_id, :user_id, :name, :lastname, :tel, :cel, :email, :study1, :study2 ] )
    end
end
