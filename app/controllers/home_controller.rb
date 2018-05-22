class HomeController < ApplicationController

  def index
    @archetype_stats = ReplayStats.new(ReplayOutcome.legend_players).winrates
  end
end
