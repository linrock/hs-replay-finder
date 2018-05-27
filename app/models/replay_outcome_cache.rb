class ReplayOutcomeCache

  EXPIRES_IN = 3.minutes

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

  def replay_outcome_ids!(query)
    results = ReplayOutcomeQuery.new(query).replay_outcomes_with_limit.pluck(:id)
    @cache.write replay_outcome_ids_cache_key(query), results, expires_in: EXPIRES_IN
    results
  end

  private

  def replay_hash_cache_key(replay_id)
    "replay_outcomes:#{replay_id}:hash"
  end

  def replay_outcome_ids_cache_key(query)
    "replay_outcomes:ids:#{query_key(query)}"
  end

  def query_key(query)
    query.sort_by {|k, _| k }.map {|k, v| "#{k}=#{v}" }.join("&")
  end
end
