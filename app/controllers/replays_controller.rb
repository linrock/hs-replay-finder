class ReplaysController < ApplicationController

  def index
    @query = {
      class: params[:class] || 'any',
      archetype: params[:archetype] || 'any',
      # outcome: params[:outcome] || 'any',
    }
    # @replays = ReplayOutcomeQuery.new(@query).replay_outcomes_with_limit
    cache = ReplayOutcomeCache.new
    replay_ids = cache.replay_outcome_ids(@query)
    t0 = Time.now
    response_json = {
      query: @query,
      replays: replay_ids.map {|id| cache.replay_json(id) },
    }.to_json
    puts "elapsed time: #{Time.now - t0}"
    render json: response_json
  end
end
