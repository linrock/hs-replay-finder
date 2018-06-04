class ReplayStatsCache

  def initialize
    @cache = Rails.cache
  end

  def route_map
    legend_stats[:route_map]
  end

  def legend_stats
    results = @cache.read cache_key
    return results if results.present?
    legend_stats!
  end

  def legend_stats!
    replay_stats = ReplayStats.new(ReplayOutcome.legend_players.since(5.days.ago))
    results = {
      route_map: replay_stats.to_path_map,
      about_winrates: {
        count: replay_stats.replays_count,
        since: replay_stats.oldest_replay_timestamp,
      }
    }
    @cache.write cache_key, results
    results
  end

  def cache_key
    "replay_stats:legend:v1"
  end
end
