class JsonResponseCache

  EXPIRES_IN = 3.minutes
  PAGE_LIMIT = 10

  def self.warm_all_caches!
    %w( 1 2 3 ).each do |page|
      ReplayOutcomeFilter::FILTERS.each do |filter|
        self.new({ path: "/", filter: filter, page: page }).json_response!
        ReplayStatsCache.new.route_map.keys.each do |path|
          self.new({ path: path, filter: filter, page: page }).json_response!
        end
      end
    end
  end

  def initialize(options = {})
    @path = options[:path] || "/"
    @cache = Rails.cache
    @filter = ReplayOutcomeFilter.get_filter(options[:filter])
    set_page options[:page].to_i
  end

  def cached_json_response
    @cache.read json_response_cache_key
  end

  def json_response
    @cache.fetch json_response_cache_key do
      json_response!
    end
  end

  def json_response!
    response_json = {
      path: @path,
      filter: @filter,
      page: @page,
      route: route,
      page_size: ReplayOutcomeQuery::PAGE_SIZE,
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

  private

  def json_response_cache_key
    "replay_outcomes:json_responses:#{@path}:#{@filter}:page=#{@page}"
  end

  def replay_outcome_cache
    @replay_outcome_cache ||= ReplayOutcomeCache.new
  end

  def replay_outcome_ids
    class_query = route || { class: 'any', archetype: 'any' }
    replay_outcome_cache.replay_outcome_ids(class_query, {
      filter: @filter,
      page: @page
    })
  end

  def route_map
    @route_map ||= RouteMap.new
  end

  def route
    @route ||= route_map.lookup(@path)
  end

  def set_page(page)
    @page = page
    @page = 1 if @page < 1
    @page = PAGE_LIMIT if @page > PAGE_LIMIT
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/error.log")
  end
end
