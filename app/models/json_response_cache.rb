class JsonResponseCache

  EXPIRES_IN = 3.minutes
  PAGE_LIMIT = 5

  def initialize(options = {})
    @path = options[:path] || "/"
    @cache = Rails.cache
    set_filter options[:filter]
    set_page options[:page].to_i
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
      filter: @filter,
      page: @page,
      replays: replay_outcome_ids.map do |id|
        begin
          replay_outcome_cache.replay_hash(id)
        rescue
          logger.error "json_response! - replay #{id}"
          nil
        end
      end.compact
    }.to_json
    @cache.write json_response_cache_key, response_json, expires_in: EXPIRES_IN
    response_json
  end

  def json_response_cache_key
    "replay_outcomes:json_responses:#{@path}:#{@filter}:page=#{@page}"
  end

  private

  def set_filter(filter)
    @filter = %w( top100 top1000 ).include?(filter) ? filter : "all"
  end

  def set_page(page)
    @page = page
    @page = 1 if @page < 1
    @page = PAGE_LIMIT if @page > PAGE_LIMIT
  end

  def replay_outcome_cache
    @replay_outcome_cache ||= ReplayOutcomeCache.new
  end

  def replay_outcome_ids
    legend_stats = ReplayStatsCache.new.legend_stats
    class_query = legend_stats[:route_map][@path] || { class: 'any', archetype: 'any' }
    replay_outcome_cache.replay_outcome_ids(class_query, {
      filter: @filter,
      page: @page
    })
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/error.log")
  end
end
