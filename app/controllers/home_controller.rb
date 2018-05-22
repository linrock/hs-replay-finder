class HomeController < ApplicationController

  def index
    @archetype_map = Archetype.to_map(ReplayOutcome.legend_players.unique_archetype_ids)
  end
end
