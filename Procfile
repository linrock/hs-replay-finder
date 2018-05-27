web: bundle exec rails s
importer: bundle exec rails runner 'RepeatingTasks.new.import_replays'
stats: bundle exec rails runner 'RepeatingTasks.new.calculate_legend_stats'
cache: bundle exec rails runner 'RepeatingTasks.new.warm_json_response_caches'
