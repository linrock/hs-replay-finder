require 'json'
require 'pry'

archetype = "219" # odd rogue
min_rank = 5

def latest_replay_filename
  max_id = Dir.glob("data/replays.*.json").map {|fn| fn[/\.(\d+)\./, 1].to_i }.max
  "data/replays.#{max_id}.json"
end

# filename = "data/replays.3.json"
filename = latest_replay_filename

puts "Searching replays from #{filename}"

replays = JSON.parse(open(filename).read)["data"]
good_replays = replays.select {|replay|
  (replay["player1_archetype"] == archetype &&
   replay["player2_won"] == "False" &&
   replay["player1_rank"].to_i < min_rank) ||
  (replay["player2_archetype"] == archetype &&
   replay["player2_won"] == "True" &&
   replay["player2_rank"].to_i < min_rank)
}

puts `echo '#{good_replays.to_json}' | jq '.'`
