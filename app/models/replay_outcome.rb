# Represents the outcome of a replay

class ReplayOutcome < ApplicationRecord

  # Imports replays fetched as JSON data from the API endpoint
  # https://hsreplay.net/api/v1/live/replay_feed/
  def self.import_from_json(json_string)
    data = JSON.parse json_string
    replay_outcomes = data["data"]
    replay_outcomes.each do |replay|
      replay_id = replay["id"]
      next if ReplayOutcome.exists?(hsreplay_id: replay_id)
      ReplayOutcome.create!(hsreplay_id: replay_id, data: replay)
    end
  end

  def self.import_from_downloaded_json
    filenames = Dir.glob("scripts/data/replays.*.json").sort_by do |name|
      name[/replays\.(\d*)\.json/, 1].to_i
    end
    filenames.each do |filename|
      begin
        import_from_json open(filename).read
      rescue
        binding.pry
      end
    end
  end

  def player1_archetype
    Archetype.name_of_archetype_id data["player1_archetype"]
  end

  def player1_is_legend?
    data["player1_legend_rank"] != "None"
  end

  def player1_won?
    data["player2_won"] == "False"
  end

  def player1_rank
    data["player1_rank"] != "None" ? data["player1_rank"] : nil
  end

  def player1_legend_rank
    player1_is_legend? ? data["player1_legend_rank"] : nil
  end

  def player2_archetype
    Archetype.name_of_archetype_id data["player2_archetype"]
  end

  def player2_is_legend?
    data["player2_legend_rank"] != "None"
  end

  def player2_won?
    data["player2_won"] == "True"
  end

  def player2_rank
    data["player2_rank"] != "None" ? data["player2_rank"] : nil
  end

  def player2_legend_rank
    player2_is_legend? ? data["player2_legend_rank"] : nil
  end

  def replay_string
    p1_rank = data["player1_rank"].to_s
    player1 = [
      player1_archetype,
      p1_rank.to_i > 0 ? "(rank #{data["player1_rank"]})"
                  : "(legend #{data["player1_legend_rank"]})"
    ].join(" ")
    p2_rank = data["player2_rank"].to_s
    player2 = [
      player2_archetype,
      p2_rank.to_i > 0 ? "(rank #{data["player2_rank"]})"
                       : "(legend #{data["player2_legend_rank"]})"
    ].join(" ")
    "#{player1} vs #{player2}"
  end

  def replay_link
    "https://hsreplay.net/replay/#{hsreplay_id}"
  end

  def print_info
    puts replay_string
    puts replay_link
    puts
  end
end
