class JsonResponseCache

  EXPIRES_IN = 3.minutes

  def initialize(path)
    @path = path || "/"
    @cache = Rails.cache
    @replay_outcome_cache = ReplayOutcomeCache.new
  end

  def cached_json_response
    @cache.read json_response_cache_key
  end

  def json_response
    results = cached_json_response
    return results unless results.nil?
    json_response!
  end

  def json_response!
    response_json = {
      path: @path,
      replays: replay_outcome_ids.map do |id|
        begin
          @replay_outcome_cache.replay_hash(id)
        rescue
          logger.error "json_response! - replay #{id}"
          nil
        end
      end.compact
    }.to_json
    @cache.write json_response_cache_key, response_json, expires_in: EXPIRES_IN
    response_json
  end

  private

  def json_response_cache_key
    "replay_outcomes:json_responses:#{@path}:v1"
  end

  def replay_outcome_ids
    legend_stats = ReplayStatsCache.new.legend_stats
    query = legend_stats[:route_map][@path] || { class: 'any', archetype: 'any' }
    @replay_outcome_cache.replay_outcome_ids(query)
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/error.log")
  end
end
