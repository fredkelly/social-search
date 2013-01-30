class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @result.selected!
    redirect_to(@result.url, status: :moved_permanently)
  end
end
