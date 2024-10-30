class QuestionsController < ApplicationController

  def show
    @question = Question.find(params[:id])
    @responses = @question.responses.order(:survey_response_id)
  end

end
