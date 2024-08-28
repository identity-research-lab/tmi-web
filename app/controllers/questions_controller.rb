class QuestionsController < ApplicationController

  def show
    @question = Question.from(params[:id])
    @responses = SurveyResponse.all.order(:created_at).reject{|sr| sr.read_attribute(@question.key).nil? }
  end

end
