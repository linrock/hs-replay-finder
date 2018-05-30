class RepeatingTasks

  def import_replays
    ReplayOutcomeImporter.new.keep_fetching
  end

  def calculate_legend_stats
    loop do
      cache = ArchetypeCache.new
      cache.archetypes_map!
      cache.path_map!
      ReplayStatsCache.new.legend_stats!
      sleep 3600
    end
  end

  def warm_json_response_caches
    loop do
      t0 = Time.now
      ["", "top100", "top1000"].each do |filter|
        JsonResponseCache.new({ path: "/", filter: filter }).json_response!
        ReplayStatsCache.new.legend_stats[:route_map].keys.each do |path|
          JsonResponseCache.new({ path: path, filter: filter }).json_response!
        end
      end
      puts "Refreshing json caches took #{Time.now - t0}s"
      sleep 120
    end
  end
end
