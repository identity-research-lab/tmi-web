class QuestionsController < ApplicationController

  def show
    @question = Question.find_by(name: params[:id])
    @responses = SurveyResponse.where("#{@question.key} IS NOT NULL").order(:created_at)
  end

end
