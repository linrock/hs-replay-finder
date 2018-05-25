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
end
