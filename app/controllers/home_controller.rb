class HomeController < ApplicationController

  def index
    @archetype_stats = ReplayStatsCache.new.legend_winrates
  end
end
