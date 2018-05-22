class ReplayStats

  def initialize(replay_outcomes)
    @replay_outcomes = replay_outcomes
  end

  def archetype_wins_and_losses(min_games = 50)
    archetype_stats = {}
    Archetype.all.each do |arch|
      archetype_stats[arch.data["id"]] = { wins: 0, losses: 0 }
    end
    @replay_outcomes.each do |outcome|
      p1_archetype = outcome.data["player1_archetype"].to_i
      p2_archetype = outcome.data["player2_archetype"].to_i
      begin
        if outcome.player1_won?
          archetype_stats[p1_archetype][:wins] += 1
          archetype_stats[p2_archetype][:losses] += 1
        else
          archetype_stats[p1_archetype][:losses] += 1
          archetype_stats[p2_archetype][:wins] += 1
        end
      rescue
        puts "missing archetype - #{p1_archetype} vs #{p2_archetype}"
      end
    end
    archetype_stats.select do |arch, counts|
      counts[:wins] + counts[:losses] > min_games
    end
  end
end
