class ReplayOutcomeCache

  def initialize
    @cache = Rails.cache
  end

  # the hash representation of a replay outcome
  def replay_hash(replay_id)
    results = @cache.read replay_hash_cache_key(replay_id)
    return results unless results.nil?
    replay_hash!(replay_id)
  end

  def replay_hash!(replay_id)
    results = ReplayOutcome.find(replay_id).to_hash
    @cache.write replay_hash_cache_key(replay_id), results
    results 
  end

  # the list of replay ids returned for a query
  def replay_outcome_ids(query)
    results = @cache.read replay_outcome_ids_cache_key(query)
    return results unless results.nil?
    replay_outcome_ids!(query)
  end

  def replay_outcome_ids!(query, expires_in = 2.minutes)
    results = ReplayOutcomeQuery.new(query).replay_outcomes_with_limit.pluck(:id)
    @cache.write replay_outcome_ids_cache_key(query), results, expires_in: expires_in
    results
  end

  # the JSON response to a query
  def json_response(query)
    results = @cache.read json_response_cache_key(query)
    return results unless results.nil?
    json_response!(query)
  end

  def json_response!(query, expires_in = 2.minutes)
    ids = replay_outcome_ids(query)
    response_json = {
      query: query,
      replays: ids.map do |id|
        begin
          replay_hash(id)
        rescue
          logger.error "json_response! - replay #{id}"
          nil
        end
      end.compact
    }.to_json
    @cache.write json_response_cache_key(query), response_json, expires_in: expires_in
    response_json
  end

  private

  def replay_hash_cache_key(replay_id)
    "replay_outcomes:#{replay_id}:hash"
  end

  def replay_outcome_ids_cache_key(query)
    "replay_outcomes:ids:#{query_key(query)}"
  end

  def json_response_cache_key(query)
    "replay_outcomes:json_response:#{query_key(query)}"
  end

  def query_key(query)
    query.sort_by {|k, _| k }.map {|k, v| "#{k}=#{v}" }.join("&")
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/error.log")
  end
end
