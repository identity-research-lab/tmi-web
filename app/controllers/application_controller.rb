class ApplicationController < ActionController::Base
	
	before_action :authenticate

	def authenticate
		Rails.logger.info("!!! => #{ENV.fetch('GENERAL_ADMISSION_PROTECTED').inspect}")
		return unless ENV.fetch('GENERAL_ADMISSION_PROTECTED') == "true"
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

end
