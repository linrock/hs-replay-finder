class HomeController < ApplicationController

  def index
    @legend_stats = ReplayStatsCache.new.legend_stats
  end
end
