class RepeatingTasks

  def import_replays
    ReplayOutcomeImporter.new.keep_fetching
  end

  def calculate_legend_stats
    loop do
      ReplayStatsCache.new.legend_stats!
      sleep 3600
    end
  end

  def warm_json_response_caches
    loop do
      t0 = Time.now
      JsonResponseCache.new("/").json_response!
      ReplayStatsCache.new.legend_stats[:route_map].keys.each do |path|
        JsonResponseCache.new(path).json_response!
      end
      puts "Refreshing json caches took #{Time.now - t0}s"
      sleep 120
    end
  end
end
