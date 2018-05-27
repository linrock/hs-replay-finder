class HomeController < ApplicationController

  def index
    cache = ReplayStatsCache.new
    @legend_stats = cache.legend_stats
    @replay_data = JsonResponseCache.new(params[:path]).cached_json_response || "{}"
  end
end
