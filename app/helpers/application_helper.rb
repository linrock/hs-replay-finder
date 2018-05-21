module ApplicationHelper
  def replay_found_at(replay)
    found_at = time_ago_in_words(replay.created_at)
    return "minutes ago" if found_at =~ /minute/
    "#{found_at} ago".gsub(/about\s+/, '')
  end
end
