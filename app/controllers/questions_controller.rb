class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @responses = @question.responses.order(:case_id)

    question_ids = Question.all.pluck(:id)
    previous_index = (question_ids.index(@question.id) - 1)
    next_index = (question_ids.index(@question.id) + 1) % question_ids.length
    @previous_question_id = question_ids[previous_index]
    @next_question_id = question_ids[next_index]

  end

  private

  def scope_nav
    @nav_context = "responses"
  end

end
