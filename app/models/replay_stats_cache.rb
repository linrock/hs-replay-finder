class ReplayStatsCache

  def initialize
    @cache = Rails.cache
  end

  def legend_winrates
    results = @cache.read cache_key
    return results if results.present?
    legend_winrates!
  end

  def legend_winrates!
    results = ReplayStats.new(ReplayOutcome.legend_players).winrates
    @cache.write cache_key, results
    results
  end

  def cache_key
    "replay_stats:winrates:legend"
  end
end
