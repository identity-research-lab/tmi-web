class SurveyResponsesController < ApplicationController
	
	def index
		@responses = SurveyResponse.all
	end
	
	def show
		@response = SurveyResponse.find(params[:id])
	end
	
end
