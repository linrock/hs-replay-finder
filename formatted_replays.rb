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
puts

replays = JSON.parse(open(filename).read)["data"]
good_replays = replays.select {|replay|
  (replay["player1_archetype"] == archetype &&
   replay["player2_won"] == "False" &&
   replay["player1_rank"].to_i < min_rank) ||
  (replay["player2_archetype"] == archetype &&
   replay["player2_won"] == "True" &&
   replay["player2_rank"].to_i < min_rank)
}

archetype_data = JSON.parse open("data/archetypes.json").read
archetype_name_map = {}
archetype_data.each do |arch|
  archetype_name_map[arch["id"].to_s] = arch["name"]
end

good_replays.each do |replay|
  p1_rank = replay["player1_rank"].to_s
  player1 = [
    archetype_name_map[replay["player1_archetype"]],
    p1_rank.to_i > 0 ? "(rank #{replay["player1_rank"]})"
                : "(legend #{replay["player1_legend_rank"]})"
  ].join(" ")
  p2_rank = replay["player2_rank"].to_s
  player2 = [
    archetype_name_map[replay["player2_archetype"]],
    p2_rank.to_i > 0 ? "(rank #{replay["player2_rank"]})"
                     : "(legend #{replay["player2_legend_rank"]})"
  ].join(" ")
  puts "#{player1} vs #{player2}"
  puts "https://hsreplay.net/replay/#{replay["id"]}"
  puts
end
