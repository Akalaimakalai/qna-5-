class SearchController < ApplicationController

  def index
    @results = ThinkingSphinx.search(params[:search])
  end
end
