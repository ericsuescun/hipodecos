class Informs::CommentsController < CommentsController
	before_action :set_commentable

	private
		def set_commentable
			@commentable = Inform.find(params[:inform_id])
		end
end