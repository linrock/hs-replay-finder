class ReplayOutcomeFilter
  FILTERS = %w( all top100 top1000 )

  def self.get_filter(filter)
    FILTERS.include?(filter) ? filter : FILTERS[0]
  end
end
