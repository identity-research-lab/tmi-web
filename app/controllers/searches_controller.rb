class SearchesController < ApplicationController

  def index
    @search ||= Search.new("")
  end

  def create
    @search = Search.new(params[:search][:query])
    render :show
  end

end
