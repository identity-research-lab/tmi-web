class ContextsController < ApplicationController

  before_action :scope_context

  def index
    @contexts = Context.all.order(:display_name)
  end

  def show
    @categories = @context.categories
    @codes = @context.codes
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil
    @isEditMode = params[:is_edit_mode] == "true"

    context_ids = Context.all.order(:display_name).pluck(:id)
    previous_index = (context_ids.index(@context.id) - 1)
    next_index = (context_ids.index(@context.id) + 1) % context_ids.length
    @previous_context_id = context_ids[previous_index]
    @next_context_id = context_ids[next_index]
  end

  def enqueue_category_suggestions
    CategorySuggestionsJob.perform_async(params[:context_id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-suggestions", partial: "/contexts/suggestions", locals: { context: @context, enqueued: params[:enqueued] })
      end
    end
  end

  private

  def scope_context
    @context = params[:id].present? ? Context.find(params[:id]) : Context.new
  end

  def scope_nav
    @nav_context = "categories"
  end

end
