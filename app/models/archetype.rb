# Represents an HS replay archetype 

class Archetype < ApplicationRecord

  def self.find_by_archetype_id(id)
    find_by("data -> 'id' = '?'", id)
  end

  def self.name_of_archetype_id(id)
    find_by_archetype_id(id).data["name"]
  end
end
