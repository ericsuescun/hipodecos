class Blocks::ObjectionsController < ObjectionsController
	before_action :set_objectionable

	private
		def set_objectionable
			@objectionable = Block.find(params[:block_id])
			
		end
end