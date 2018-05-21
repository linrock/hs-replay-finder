# Represents the outcome of a replay

class ReplayOutcome < ApplicationRecord

  # Imports replays fetched as JSON data from the API endpoint
  # https://hsreplay.net/api/v1/live/replay_feed/
  def self.import_from_json
    open(Rails.root.join("scripts/data/replays.746.json").to_s) do |f|
      data = JSON.parse f.read
      results = data["data"]
      results.each do |replay|
        replay_id = replay["id"]
        next if ReplayOutcome.exists?(hsreplay_id: replay_id)
        ReplayOutcome.create!(hsreplay_id: replay_id, data: replay)
      end
    end
  end

  def self.find_by_criteria
    archetype_id = '219'
    min_rank = 5
    where("
      (
        data ->> 'player1_archetype' = ? AND
        data ->> 'player2_won' = 'False' AND
        (
          data -> 'player1_rank' < '?' OR
          data ->> 'player1_legend_rank' != 'None'
        )
      ) OR
      (
        data ->> 'player2_archetype' = ? AND
        data ->> 'player2_won' = 'True' AND
        (
          data -> 'player2_rank' < '?' OR
          data ->> 'player2_legend_rank' != 'None'
        )
      )
    ", archetype_id, min_rank, archetype_id, min_rank)
  end

  def replay_string
    p1_rank = data["player1_rank"].to_s
    player1 = [
      Archetype.name_of_archetype_id(data["player1_archetype"]),
      p1_rank.to_i > 0 ? "(rank #{data["player1_rank"]})"
                  : "(legend #{data["player1_legend_rank"]})"
    ].join(" ")
    p2_rank = data["player2_rank"].to_s
    player2 = [
      Archetype.name_of_archetype_id(data["player2_archetype"]),
      p2_rank.to_i > 0 ? "(rank #{data["player2_rank"]})"
                       : "(legend #{data["player2_legend_rank"]})"
    ].join(" ")
    "#{player1} vs #{player2}"
  end

  def replay_link
    "https://hsreplay.net/replay/#{hsreplay_id}"
  end
end
