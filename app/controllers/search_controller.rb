class SearchController < ApplicationController

  def index
    @results = SearchService.do_search(params[:search], params[:classes])
  end
end
