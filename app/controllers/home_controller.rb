class HomeController < ApplicationController

  def index
    cache = ReplayStatsCache.new
    @legend_stats = cache.legend_stats
    @data = "{}"
  end
end
