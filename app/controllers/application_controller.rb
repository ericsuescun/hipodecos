class ApplicationController < ActionController::Base
	private
	 
	    def after_sign_in_path_for(user)
	       static_pages_welcome_user_path
	    end

	    def after_sign_in_path_for(admin)
	       static_pages_welcome_admin_path
	    end

	    def after_sign_in_path_for(patient)
	       results_path
	    end

	    def after_sign_out_path_for(patient)
	       static_pages_home_path
	    end
end
