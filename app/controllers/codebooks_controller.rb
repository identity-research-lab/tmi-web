class CodebooksController < ApplicationController

  USERS = { ENV['GENERAL_ADMISSION_USERNAME'] => ENV['GENERAL_ADMISSION_PASSWORD'] }

  def index
    @contexts = Question::QUESTIONS
  end

  def show
    @context = params[:id]
    @context_key = Question.from(@context).context
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil
    @section_name = Question::QUESTIONS[@context.gsub("class","klass").to_sym]
    @question = Question.from(@context)
    
    # These modulo gymnastics allow the previous/next arrows to wrap around
    sections = Question::QUESTIONS.keys
    previous_index = (sections.index(@context.gsub("class","klass").to_sym) - 1) % sections.length
    next_index = (sections.index(@context.gsub("class","klass").to_sym) + 1) % sections.length
    @previous_section = sections[previous_index]
    @next_section = sections[next_index]

    if @question.identity_field?
      # Identity fields have associated Identity objects.
      @frequencies = Identity.histogram(@context)
    elsif @question.experience_field?
      # Experience fields have associated Code and Category objects.
      @frequencies = Code.histogram(@context_key)
      @categories_histogram = Category.histogram(@context_key)
      @total_codes = @categories_histogram.values.sum
    end

  end

  def enqueue_categories
    context = Question.from(params[:codebook_id]).context
    CategoryExtractorJob.perform_async(context)
    redirect_to(action: :show, id: params[:codebook_id], params: {enqueued_at: Time.now.strftime("%s")})
  end

end
