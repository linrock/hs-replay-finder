require 'open-uri'

class ReplayOutcomeImporter

  API_ENDPOINT = "https://hsreplay.net/api/v1/live/replay_feed/"

  def keep_fetching
    n_consecutive_errors = 0
    loop do
      json_string = open(API_ENDPOINT).read
      begin
        ReplayOutcome.import_from_json json_string
        sleep 60
      rescue => e
        puts "#{e.class.name}: #{e.message}"
        puts e.backtrace
        n_consecutive_errors += 1
        if n_consecutive_errors > 3
          puts "Too many failures in a row. Exiting..."
          exit 1
        end
        sleep 60 ** n_consecutive_errors
      else
        n_consecutive_errors = 0
      end
    end
  end
end
