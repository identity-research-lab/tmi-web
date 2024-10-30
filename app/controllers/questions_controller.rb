class QuestionsController < ApplicationController

  def show
    @question = Question.find(params[:id])
    @responses = @question.responses.where("value != ''").order(:survey_response_id)
  end

end
