require 'open-uri'

class ReplayOutcomeImporter

  def keep_fetching
    loop do
      json_string = open("https://hsreplay.net/api/v1/live/replay_feed/").read
      ReplayOutcome.import_from_json json_string
      sleep 60
    end
  end
end
