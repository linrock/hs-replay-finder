# Represents the outcome of a replay

class ReplayOutcome < ApplicationRecord

  def self.find_by_criteria
    where("
      (
        data ->> 'player1_archetype' = ? AND
        data ->> 'player2_won' = 'False' AND
        (
          data -> 'player1_rank' < '5' OR
          data ->> 'player1_legend_rank' != 'None'
        )
      ) OR
      (
        data ->> 'player2_archetype' = ? AND
        data ->> 'player2_won' = 'True' AND
        (
          data -> 'player2_rank' < '5' OR
          data ->> 'player2_legend_rank' != 'None'
        )
      )
    ", '219', '219')
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
    "https://hsreplay.net/replay/#{replay["id"]}"
  end
end
