class ReplaysController < ApplicationController

  def index
    @query = {
      class: params[:class] || 'any',
      archetype: params[:archetype] || 'any',
      outcome: params[:outcome] || 'any',
    }
    r_query = ReplayOutcomeQuery.new(@query)
    @replays = r_query.replay_outcomes.order('id DESC').limit(100)
    render json: {
      meta: { count: @replays.count }.merge(r_query.meta_info),
      query: @query,
      replays: @replays.map do |r|
        {
          p1: {
            archetype: r.player1_archetype,
            is_legend: r.player1_is_legend?,
            rank: r.player1_is_legend? ? r.player1_legend_rank : r.player1_rank,
          },
          p2: {
            archetype: r.player2_archetype,
            is_legend: r.player2_is_legend?,
            rank: r.player2_is_legend? ? r.player2_legend_rank : r.player2_rank,
          },
          winner: r.player1_won? ? 'p1' : 'p2',
          link: r.replay_link,
          found_at: r.created_at,
        }
      end
    }
  end
end
