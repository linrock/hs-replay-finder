class ReplayStatsCache

  def initialize
    @cache = Rails.cache
  end

  def route_map
    legend_stats[:route_map]
  end

  def legend_stats
    results = @cache.read legend_stats_cache_key
    return results unless results.nil?
    legend_stats!
  end

  def legend_stats!
    results = {
      route_map: replay_stats.to_route_map,
      about_winrates: {
        count: replay_stats.replays_count,
        since: replay_stats.oldest_replay_timestamp,
      }
    }
    @cache.write legend_stats_cache_key, results
    results
  end

  private

  def replay_stats
    @replay_stats ||= ReplayStats.new(ReplayOutcome.legend_players.since(5.days.ago))
  end

  def legend_stats_cache_key
    "replay_stats:legend_stats:v1"
  end
end
