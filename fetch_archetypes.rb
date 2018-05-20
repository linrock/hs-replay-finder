require 'open-uri'

open("data/archetypes.json", "w") do |f|
  f.write open("https://hsreplay.net/api/v1/archetypes").read
end
