class QuestionsController < ApplicationController

  def show
    @question = Question.find(params[:id])
    @responses = @question.responses.order(:case_id)
  end

end
