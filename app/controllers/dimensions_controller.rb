class DimensionsController < ApplicationController

  before_action :scope_dimension

  def index
    @dimensions = Dimension.all.order(:display_name)
  end

  def show
    @categories = @dimension.categories
    @codes = @dimension.codes
    @enqueued_at = params[:enqueued_at].present? ? Time.at(params[:enqueued_at].to_i).strftime("%T %Z") : nil
    @isEditMode = params[:is_edit_mode] == "true"

    dimension_ids = Dimension.all.order(:display_name).pluck(:id)
    previous_index = (dimension_ids.index(@dimension.id) - 1)
    next_index = (dimension_ids.index(@dimension.id) + 1) % dimension_ids.length
    @previous_dimension_id = dimension_ids[previous_index]
    @next_dimension_id = dimension_ids[next_index]
  end

  def enqueue_category_suggestions
    CategorySuggestionsJob.perform_async(params[:dimension_id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("frame-suggestions", partial: "/dimensions/suggestions", locals: { dimension: @dimension, enqueued: params[:enqueued] })
      end
    end
  end

  private

  def scope_dimension
    @dimension = params[:id].present? ? Dimension.find(params[:id]) : Dimension.new
  end

  def scope_nav
    @nav_context = "categories"
  end

end
