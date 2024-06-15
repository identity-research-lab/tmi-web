class SurveyResponsesController < ApplicationController
	
	USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }
	
	before_action :authenticate
	
	def authenticate
		authenticate_or_request_with_http_digest("Application") do |name|
			USERS[name]
		end
	end

	def index
		if @theme = params.permit(:theme)[:theme]
			@responses = SurveyResponse.where("? = ANY (themes)", @theme).order(:created_at)
		else
			@responses = SurveyResponse.all.order(:created_at)
		end
	end
	
	def show
		@theme = params.permit(:theme)[:theme]
		@response = SurveyResponse.find(params[:id])
		@total_responses = SurveyResponse.all.count
		@previous_response = SurveyResponse.where("created_at < ?", @response.created_at).order("created_at DESC").limit(1).first
		@next_response = SurveyResponse.where("created_at > ?", @response.created_at).order("created_at ASC").limit(1).first
		@categories = Persona.find_or_initialize_by(survey_response_id: @response.id).categories.sort{ |a,b| "#{a.context}.#{a.name}" <=> "#{b.context}.#{b.name}" }
	end
	
	def new
	end
	
	def create
		SurveyResponse.import(params.permit(:csv)[:csv])
		redirect_to survey_responses_path
	end
	
	def update
		@response = SurveyResponse.find(params[:id])
	
		unless @response.update(response_params)
			render :edit, status: :unprocessable_entity
		end
	end

	private

		def response_params
			params.require(:survey_response).permit(themes: [], age_exp_codes: [], klass_exp_codes: [], race_ethnicity_exp_codes: [], religion_exp_codes: [], disability_exp_codes: [], neurodiversity_exp_codes: [], gender_exp_codes: [], lgbtqia_exp_codes: [], age_id_codes: [], klass_id_codes: [], race_ethnicity_id_codes: [], religion_id_codes: [], disability_id_codes: [], neurodiversity_id_codes: [], gender_id_codes: [], lgbtqia_id_codes: [], pronouns_id_codes: [], pronouns_exp_codes: [], pronouns_feel_codes: [], affinity_codes: [], notes_codes: [])
		end

end


