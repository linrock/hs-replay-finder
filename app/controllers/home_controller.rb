class HomeController < ApplicationController

  def index
    @legend_stats = ReplayStatsCache.new.legend_stats
    if request.path == "/"
      @data = ReplayOutcomeCache.new.json_response_cached({
        class: 'any',
        archetype: 'any'
      })
    end
    @data ||= "{}"
  end
end
