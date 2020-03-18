class DownloadsController < ApplicationController
	def show
		respond_to do |format|
			format.pdf { send_inform_pdf }
			if Rails.env.development?
				format.html { render_sample_html }
			end
		end
	end

	private

		def inform
			Inform.find(params[:inform_id])
		end

		def download
			Download.new(inform)
		end

		def send_inform_pdf
			send_file download.to_pdf, download_attributes
		end

		def render_sample_html
			render download.render_attributes
		end

		def download_attributes
			{
				filename: download.filename,
				type: "application/pdf",
				disposition: "inline"
			}
		end
	
	
end