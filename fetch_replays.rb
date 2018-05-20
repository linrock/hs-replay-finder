require 'open-uri'

json_data = open("https://hsreplay.net/api/v1/live/replay_feed/").read
max_id = Dir.glob("data/replays.*.json").map {|fn| fn[/\.(\d+)\./, 1].to_i }.max
new_id = max_id + 1

filename = "replays.#{new_id}.json"
open("data/#{filename}", "w") do |f|
  f.write json_data
end
puts "Writing replays to #{filename}"
