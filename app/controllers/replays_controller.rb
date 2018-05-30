class ReplaysController < ActionController::API

  def index
    render json: JsonResponseCache.new(params).json_response
  end
end
