class StaticController < ApplicationController

  def about
  end

	def home
	end
	
  private

  def scope_nav
    @nav_context = "about"
  end

end
