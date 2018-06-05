class JsonResponse
  PAGE_LIMIT = 10

  def initialize(options = {})
    @path = options[:path] || "/"
    @filter = ReplayOutcomeFilter.get_filter(options[:filter])
    @page = get_page options[:page].to_i
  end

  def to_hash
    {
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
    }
  end

  def to_json
    to_hash.to_json
  end

  def cache_key
    "replay_outcomes:json_responses:#{@path}:#{@filter}:page=#{@page}"
  end

  private

  def replay_outcome_ids
    class_query = route || { class: 'any', archetype: 'any' }
    replay_outcome_cache.replay_outcome_ids(class_query, {
      filter: @filter,
      page: @page
    })
  end

  def replay_outcome_cache
    @replay_outcome_cache ||= ReplayOutcomeCache.new
  end

  def route_map
    @route_map ||= RouteMap.new
  end

  def route
    @route ||= route_map.lookup(@path)
  end

  def get_page(page)
    return 1 if page < 1
    return PAGE_LIMIT if page > PAGE_LIMIT
    page
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/error.log")
  end
end
