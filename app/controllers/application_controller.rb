class ApplicationController < ActionController::Base

	before_action :authenticate

	# If http auth is enabled, challenge the browser for a username and password as defined in the environment variables.
	def authenticate
		return unless ENV.fetch('GENERAL_ADMISSION_PROTECTED',nil) == "true"
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

end
