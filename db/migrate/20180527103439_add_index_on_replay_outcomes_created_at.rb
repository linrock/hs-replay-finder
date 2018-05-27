class AddIndexOnReplayOutcomesCreatedAt < ActiveRecord::Migration[5.2]
  def change
    add_index :replay_outcomes, :created_at, order: { created_at: :desc }
  end
=begin
    partial_index = 
      "(data ->> 'player1_legend_rank'::text <> 'None'::text AND
        data ->> 'player2_legend_rank'::text <> 'None'::text)"
    add_index :replay_outcomes,
      partial_index,
      order: { created_at: :desc },
      name: "index_replay_outcomes_on_recent_legend_games"
=end
end
