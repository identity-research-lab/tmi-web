class ApplicationController < ActionController::Base

	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }

	before_action :authenticate
	before_action :scope_nav

	# If http auth is enabled, challenge the browser for a username and password as defined in the environment variables.
	def authenticate
		return unless ENV.fetch('GENERAL_ADMISSION_PROTECTED', nil) == "true"
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def scope_nav
		@nav_context = ""
	end

end
