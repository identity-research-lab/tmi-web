class ThemesController < ApplicationController

  def index
    @contexts = Theme::CONTEXTS
  end

  def show
    @context = params[:id]
    @context_name = Theme::CONTEXTS[params[:id]]
    @themes = Theme.where(context: @context)
    @categories = Category.where(context: @context)
    @codes = Code.where(context: @context)
  end

end
