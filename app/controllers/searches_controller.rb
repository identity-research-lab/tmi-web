class SearchesController < ApplicationController

  def index
    @search ||= Search.new("")
  end

  def create
    @search = Search.new(params[:search][:query])
    Rails.logger.info("!!! => #{@search.responses.count}")
    render :show
  end

end
