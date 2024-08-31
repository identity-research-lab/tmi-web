class QuestionsController < ApplicationController

  def show
    @question = Question.from(params[:id])
    @responses = SurveyResponse.where("#{@question.key} IS NOT NULL").order(:created_at)
  end

end
