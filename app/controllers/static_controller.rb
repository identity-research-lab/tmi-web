class StaticController < ApplicationController

  def about
  end

  private

  def scope_nav
    @nav_context = "about"
  end

end
