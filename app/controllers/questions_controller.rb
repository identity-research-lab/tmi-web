class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end
  
  def show
    @question = Question.find(params[:id])
    @responses = @question.responses.order(:case_id)
  end

end
