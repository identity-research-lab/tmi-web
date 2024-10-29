class CodebooksController < ApplicationController

  def index
    @questions = Question.all.order(:created_at)
  end

  def show
    @question = Question.find(params[:id])
    @context = @question.context
    @context_key = @context.name
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil

    # Support the previous/next navigation controls

    sections = Question.all.pluck(:id)
    previous_index = (sections.index(@question.id) - 1)
    next_index = (sections.index(@question.id) + 1) % sections.length
    @section_name = @question.label
    @previous_section = sections[previous_index]
    @next_section = sections[next_index]

    if @question.is_identity?
      # Identity fields have associated Identity objects.
      @frequencies = Identity.histogram(@context.name)
      @frequencies_by_keys = @frequencies.sort{|a, b| a[0] <=> b[0]}
      @frequencies_by_values = @frequencies.sort{|a, b| a[1] <=> b[1]}
    else
      # Experience fields have associated Code and Category objects.
      @frequencies = Code.histogram(@context.name)
      @frequencies_by_keys = @frequencies.sort{|a, b| a[0] <=> b[0]}
      @frequencies_by_values = @frequencies.sort{|a, b| a[1] <=> b[1]}
      @categories_histogram = Category.histogram(@context.name)
      @total_codes = @categories_histogram.values.sum
      @codes = Code.where(context: params[:id].gsub("klass", "class").gsub("_exp", "").gsub("_", "-"))
    end

  end

  def enqueue_categories
    context = Question.find(params[:codebook_id]).context.name
    CategoryExtractorJob.perform_async(context)
    redirect_to(action: :show, id: params[:codebook_id], params: {enqueued_at: Time.now.strftime("%s")})
  end

end
