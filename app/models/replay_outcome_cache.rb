class ReplayOutcomeCache

  def initialize
    @cache = Rails.cache
  end

  def replay_json(replay_id)
    results = @cache.read replay_json_cache_key(replay_id)
    return results if results.present?
    replay_json!(replay_id)
  end

  def replay_json!(replay_id)
    results = ReplayOutcome.find(replay_id).to_json
    @cache.write replay_json_cache_key(replay_id), results
    results 
  end

  def replay_outcome_ids(query)
    results = @cache.read replay_outcome_ids_cache_key(query)
    return results if results.present?
    replay_outcome_ids!(query)
  end

  def replay_outcome_ids!(query, expires_in = 2.minutes)
    results = ReplayOutcomeQuery.new(query).replay_outcomes_with_limit.pluck(:id)
    @cache.write replay_outcome_ids_cache_key(query), results, expires_in: expires_in
    results
  end

  private

  def replay_json_cache_key(replay_id)
    "replay_outcomes:#{replay_id}:json"
  end

  def replay_outcome_ids_cache_key(query)
    query_key = query.sort_by {|k, _| k }.map {|k, v| "#{k}=#{v}" }.join("&")
    "replay_outcome_ids:query:#{query_key}"
  end
end
