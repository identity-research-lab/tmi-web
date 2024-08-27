class CodebooksController < ApplicationController

  USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }

  def index
    @contexts = Question::QUESTIONS
  end

  def show
    @context = params[:id]
    @question = Question.from(@context)
    @context_key = @question.context
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil

    # Support the previous/next navigation controls
    sections = Question::QUESTIONS.keys.map(&:to_s)
    previous_index = (sections.index(@question.key) - 1)
    next_index = (sections.index(@question.key) + 1) % sections.length
    @section_name = @question.label
    @previous_section = sections[previous_index]
    @next_section = sections[next_index]

    if @question.identity_field?
      # Identity fields have associated Identity objects.
      @frequencies = Identity.histogram(@context)
    elsif @question.experience_field?
      # Experience fields have associated Code and Category objects.
      @frequencies = Code.histogram(@context)
      @categories_histogram = Category.histogram(@context)
      @total_codes = @categories_histogram.values.sum
    end

  end

  def enqueue_categories
    context = Question.from(params[:codebook_id]).context
    CategoryExtractorJob.perform_async(context)
    redirect_to(action: :show, id: params[:codebook_id], params: {enqueued_at: Time.now.strftime("%s")})
  end

end
