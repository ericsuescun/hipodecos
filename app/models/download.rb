require "render_anywhere"

class Download
	include RenderAnywhere
	
	def initialize(inform)
		@inform = inform
	end
	
	def to_pdf
		kit = PDFKit.new(as_html)
		kit.to_file('tmp/inform.pdf')
	end

	def filename
		'Inform #{inform.tag_code}.pdf'
	end

	def render_attributes
		{
			template: "informs/pdf", layout: 'inform_pdf', locals: { inform: inform }
		}
	end

	private

		attr_reader :inform

		def as_html
			render render_attributes
		end
	
end