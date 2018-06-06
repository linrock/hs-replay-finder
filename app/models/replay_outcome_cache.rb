class ReplayOutcomeCache
  EXPIRES_IN = 3.minutes

  def initialize
    @cache = Rails.cache
  end

  # the hash representation of a replay outcome
  def replay_hash(replay_id)
    @cache.fetch replay_hash_cache_key(replay_id) do
      replay_hash!(replay_id)
    end
  end

  def replay_hash!(replay_id)
    ReplayOutcome.find(replay_id).to_hash
  end

  # the list of replay ids returned for a query
  def replay_outcome_ids(query, options = {})
    @cache.fetch(replay_outcome_ids_cache_key(query, options), expires_in: EXPIRES_IN) do
      replay_outcome_ids!(query, options)
    end
  end

  def replay_outcome_ids!(query, options = {})
    ReplayOutcomeQuery.new(query)
      .replay_outcomes(page = options[:page])
      .filter(options[:filter])
      .pluck(:id)
  end

  private

  def replay_hash_cache_key(replay_id)
    "replay_outcomes:#{replay_id}:hash"
  end

  def replay_outcome_ids_cache_key(query, options)
    "replay_outcomes:ids:#{query_key(query)}:#{options[:filter]}:page=#{options[:page]}"
  end

  def query_key(query)
    query.sort_by {|k, _| k }.map {|k, v| "#{k}=#{v}" }.join("&")
  end
end
