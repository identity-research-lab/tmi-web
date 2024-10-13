class ThemesController < ApplicationController

  def index
    @contexts = Question::QUESTIONS
  end

  def show
    @context = params[:id].gsub("class", "klass")
    @themes = Theme.where(context: @context)
    @categories = Category.where(context: @context)
    @codes = Code.where(context: @context)
  end

end
