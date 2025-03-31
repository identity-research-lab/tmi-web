class CodebooksController < ApplicationController

  def index
    @questions = Question.all.order(:created_at)
  end

  def show
    @question = Question.find(params[:id])
    @dimension = @question.dimension
    @categories = @dimension.categories
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
      @frequencies = Identity.histogram(@dimension.name)
      @frequencies_by_keys = @frequencies.sort{|a, b| a[0] <=> b[0]}
      @frequencies_by_values = @frequencies.sort{|a, b| a[1] <=> b[1]}
    else
      # Experience fields have associated Code and Category objects.
      @frequencies = Code.histogram(@dimension.name)
      @frequencies_by_keys = @frequencies.sort{|a, b| a[0] <=> b[0]}
      @frequencies_by_values = @frequencies.sort{|a, b| a[1] <=> b[1]}
      @categories_histogram = Category.histogram(@dimension.name)
      @total_codes = @categories_histogram.values.sum
      @codes = Code.where(dimension: @dimension.name)
    end

  end

  private

  def scope_nav
    @nav_context = "codebooks"
  end

end
