class ReplayStats

  # min number of games for an archetype to be considered
  MIN_GAMES = 50

  def initialize(replay_outcomes)
    @replay_outcomes = replay_outcomes
  end

  def archetype_wins_and_losses
    archetype_stats = {}
    Archetype.all.each do |arch|
      archetype_stats[arch.data["id"]] = { wins: 0, losses: 0 }
    end
    @replay_outcomes.each do |outcome|
      p1_arch = outcome.data["player1_archetype"].to_i
      p2_arch = outcome.data["player2_archetype"].to_i
      if archetype_stats[p1_arch].nil? || archetype_stats[p2_arch].nil?
        logger.error "archetype_wins_and_losses - replay #{outcome.id} (#{p1_arch} vs #{p2_arch})"
        next
      end
      if outcome.player1_won?
        archetype_stats[p1_arch][:wins] += 1
        archetype_stats[p2_arch][:losses] += 1
      else
        archetype_stats[p1_arch][:losses] += 1
        archetype_stats[p2_arch][:wins] += 1
      end
    end
    archetype_stats.select do |_, counts|
      counts[:wins] + counts[:losses] > MIN_GAMES
    end
  end

  # does not ignore mirror matchups
  def wins_and_losses
    wins_and_losses = {}
    archetype_wins_and_losses.map do |arch_id, counts|
      archetype = Archetype.find_by_archetype_id(arch_id)
      class_name = archetype.data["player_class_name"].capitalize
      wins_and_losses[class_name] ||= { wins: 0, losses: 0, archetypes: {} }
      wins_and_losses[class_name][:wins] += counts[:wins]
      wins_and_losses[class_name][:losses] += counts[:losses]
      wins_and_losses[class_name][:archetypes][archetype.data["name"]] = counts
    end
    wins_and_losses
  end

  def winrates
    wins_and_losses.each do |class_name, stats|
      winrate = 100.0 * stats[:wins] / (stats[:wins] + stats[:losses])
      stats[:winrate] = "%0.1f" % winrate
      stats.delete(:wins)
      stats.delete(:losses)
      stats[:archetypes] = Hash[stats[:archetypes].map do |arch_name, arch_stats|
        winrate = 100.0 * arch_stats[:wins] / (arch_stats[:wins] + arch_stats[:losses])
        arch_stats.delete(:wins)
        arch_stats.delete(:losses)
        [
          arch_name.gsub(/#{class_name}\z/, '').strip,
          arch_stats[:winrate] = "%0.1f" % winrate
        ]
      end]
      [
        class_name,
        stats
      ]
    end
  end

  def replays_count
    count = @replay_outcomes.count
    count.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def oldest_replay_timestamp
    @replay_outcomes.order("created_at ASC").first.created_at
  end

  private

  def logger
    @logger ||= Logger.new "#{Rails.root}/log/error.log"
  end
end
