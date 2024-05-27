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
		@themes_histogram = @response.themes.inject({}) { |acc, theme| acc[theme] = SurveyResponse.where("? = ANY (themes)", theme).count; acc }

		if @theme
			@previous_response = SurveyResponse.where("? = ANY (themes)", @theme).where("created_at < ?", @response.created_at).order("created_at DESC").limit(1).first
			@next_response = SurveyResponse.where("? = ANY (themes)", @theme).where("created_at > ?", @response.created_at).order("created_at ASC").limit(1).first
		else
			@previous_response = SurveyResponse.where("created_at < ?", @response.created_at).order("created_at DESC").limit(1).first
			@next_response = SurveyResponse.where("created_at > ?", @response.created_at).order("created_at ASC").limit(1).first
		end
	end
	
	def new
	end
	
	def create
		SurveyResponse.refresh_from_upload(params.permit(:csv)[:csv])
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
			params.require(:survey_response).permit(themes: [], age_exp_tags: [], klass_exp_tags: [], race_ethnicity_exp_tags: [], religion_exp_tags: [], disability_exp_tags: [], neurodiversity_exp_tags: [], gender_exp_tags: [], lgbtqia_exp_tags: [], age_id_tags: [], klass_id_tags: [], race_ethnicity_id_tags: [], religion_id_tags: [], disability_id_tags: [], neurodiversity_id_tags: [], gender_id_tags: [], lgbtqia_id_tags: [], pronouns_id_tags: [], pronouns_exp_tags: [], pronouns_feel_tags: [], affinity_tags: [], notes_tags: [])
		end

end


