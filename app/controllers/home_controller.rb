class HomeController < ApplicationController

  def index
    @archetype_map = Archetype.to_map
  end
end
