class ReplaysController < ActionController::API

  def index
    render json: JsonResponseCache.new(params[:path]).json_response
  end
end
