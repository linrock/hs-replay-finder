module ApplicationHelper
  def replay_found_at(replay)
    found_at = time_ago_in_words(replay.created_at)
    if found_at =~ /minutes/
      return "just now"
    end
    "#{found_at} ago".gsub(/about\s+/, '')
  end
end
