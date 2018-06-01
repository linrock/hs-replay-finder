require 'open-uri'

class ReplayOutcomeImporter

  API_ENDPOINT = "https://hsreplay.net/api/v1/live/replay_feed/"

  def keep_fetching
    n_consecutive_errors = 0
    loop do
      begin
        json_string = open(API_ENDPOINT).read
        import_from_json_api_response json_string
      rescue => e
        puts "#{e.class.name}: #{e.message}"
        puts e.backtrace
        n_consecutive_errors += 1
        if n_consecutive_errors > 6
          puts "Too many failures in a row. Exiting..."
          exit 1
        end
        sleep 60 * 2 ** n_consecutive_errors
      else
        n_consecutive_errors = 0
        sleep 180
      end
    end
  end

  def import_from_json_api_response(json_string)
    num_saved = 0
    data = JSON.parse json_string
    replay_outcomes = data["data"]
    replay_outcomes.each do |replay|
      hsreplay_id = replay["id"]
      next if ReplayOutcome.exists?(hsreplay_id: hsreplay_id)
      replay_outcome = ReplayOutcome.new(hsreplay_id: hsreplay_id, data: replay)
      if replay_outcome.valid?
        replay_outcome.save!
        num_saved += 1
      else
        logger.error "hsreplay #{hsreplay_id} - #{replay.to_json}"
      end
    end
    evt_logger.info "Saved #{num_saved} out of #{replay_outcomes.length} replays"
    true
  end

  # Imports replays fetched as JSON data from the API endpoint
  def self.import_from_downloaded_json
    filenames = Dir.glob("scripts/data/replays.*.json").sort_by do |name|
      name[/replays\.(\d*)\.json/, 1].to_i
    end
    filenames.each do |filename|
      begin
        import_from_json_api_response open(filename).read
      rescue
        binding.pry
      end
    end
  end

  def evt_logger
    @evt_logger ||= Logger.new("#{Rails.root}/log/importer.log")
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/error.log")
  end
end
