class SearchController < ApplicationController

  def index
    @results = SearchService.new(params[:search], scope: params[:classes]).call
  end
end
