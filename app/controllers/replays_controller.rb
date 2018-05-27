class ReplaysController < ActionController::API

  def index
    cache = ReplayOutcomeCache.new
    render json: cache.json_response(params[:path])
  end
end
