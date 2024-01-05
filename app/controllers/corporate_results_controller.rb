class CorporateResultsController < ApplicationController
  before_action :authenticate_patient!
  before_action :set_branch, only: :index

  def index
    if current_patient.corporate
      @branch = Branch.where(initials: branch_initials).take

      unless params[:start_date].present? && params[:end_date].present?
        params[:start_date] = Date.today
        params[:end_date] = Date.today
      end
      @informs = Inform.where(branch_id: @branch.id, receive_date: params[:start_date]..params[:end_date])
    else
      render :not_permitted
    end
  end

  def show
    @source = 'corporate_results'
    if current_patient.corporate
      @inform = Inform.find(params[:id])

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
      # @pathologists = []
      # # @inform.diagnostics.each do |diagnostic|
      # #  	@pathologists << User.where(id: diagnostic.user_id).first
      # # end
      # @pathologists << User.where(id: @inform.pathologist_id).first if @inform.pathologist_id
      # @pathologists = @pathologists.uniq
      # if @inform.inf_status != "downloaded"
      # 	@inform.update(inf_status: "downloaded", download_date: Time.now)
      # end
    else
      render :not_permitted
    end
  end

  private

  def branch_initials
    current_patient.id_number.split('-').first
  end

  def set_branch
    @branch = Branch.where(initials: params[:branch]).take
  end
end
