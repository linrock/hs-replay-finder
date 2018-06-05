class JsonResponseCache
  EXPIRES_IN = 3.minutes

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
    @cache = Rails.cache
    @json_response = JsonResponse.new(options)
  end

  def cached_json_response
    @cache.read cache_key
  end

  def json_response
    @cache.fetch cache_key do
      json_response!
    end
  end

  def json_response!
    json_response_string = @json_response.to_json
    @cache.write cache_key, json_response_string, expires_in: EXPIRES_IN
    json_response_string
  end

  private

  def cache_key
    @json_response.cache_key
  end
end
