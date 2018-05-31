class ReplayOutcomeQuery

  PAGE_SIZE = 100

  def initialize(query = {})
    @class = query[:class] || 'any'
    @archetype = query[:archetype] || 'any'
    @outcome = query[:outcome] || 'any'
  end

  def replay_outcomes_with_limit(page = 1)
    replay_outcomes.order('id DESC').limit(PAGE_SIZE).offset((page - 1) * PAGE_SIZE)
  end

  def replay_outcomes
    rank_query = "
      data ->> 'player1_legend_rank' != 'None'
      AND
      data ->> 'player2_legend_rank' != 'None'
    "
    p1_query = [
      ("data ->> 'player1_archetype' IN (?)" if archetype_ids),
      ("data ->> 'player2_won' = '#{(!winning_outcome?).to_s.capitalize}'" unless any_outcome?),
    ].compact.join(" AND ")
    p2_query = [
      ("data ->> 'player2_archetype' IN (?)" if archetype_ids),
      ("data ->> 'player2_won' = '#{(winning_outcome?).to_s.capitalize}'" unless any_outcome?),
    ].compact.join(" AND ")
    query = [
      rank_query,
      ("((#{p1_query}) OR (#{p2_query}))" if p1_query.present? && p2_query.present?)
    ].compact.join (" AND ")
    prepared_variables = [(archetype_ids if archetype_ids)].compact
    ReplayOutcome.where(query, *prepared_variables*2)
  end

  def archetype_ids
    return @archetype_ids if defined? @archetype_ids
    @archetype_ids = archetype_ids!
  end

  def archetype_ids!
    return if @class == 'any'
    if @archetype != 'any'
      [Archetype.id_by_archetype_name("#{@archetype} #{@class}").to_s]
    else
      Archetype.ids_by_class_name @class
    end
  end

  def winning_outcome?
    @outcome == 'win'
  end

  def any_outcome?
    @outcome == 'any'
  end

  def to_query
    {
      class: @class,
      archetype: @archetype,
      outcome: @outcome,
    }
  end
end
