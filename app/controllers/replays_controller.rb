class ReplaysController < ActionController::API

  def index
    @query = {
      class: params[:class] || 'any',
      archetype: params[:archetype] || 'any',
      # outcome: params[:outcome] || 'any',
    }
    # @replays = ReplayOutcomeQuery.new(@query).replay_outcomes_with_limit
    cache = ReplayOutcomeCache.new
    t0 = Time.now
    response = cache.json_response(@query)
    puts "Time to render JSON: #{Time.now - t0}"
    render json: response
  end
end
