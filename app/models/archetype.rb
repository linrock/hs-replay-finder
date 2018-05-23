# Represents an HS replay archetype 

class Archetype < ApplicationRecord

  def self.find_by_archetype_id(id)
    find_by("data ->> 'id' = ?", id.to_s)
  end

  def self.name_of_archetype_id(id, use_cache = true)
    if use_cache
      ArchetypeCache.new.name_of_archetype_id id
    else
      find_by_archetype_id(id).data["name"]
    end
  end

  def self.id_by_archetype_name(archetype_name)
    find_by("LOWER(data ->> 'name') = ?", archetype_name.downcase).data["id"]
  end

  def self.ids_by_class_name(class_name)
    where("LOWER(data ->> 'name') LIKE ?", "% #{class_name.downcase}")
      .pluck("data ->> 'id'")
  end

  # class -> [archetype, ...]
  def self.to_map(archetype_ids = nil)
    archetypes = if archetype_ids
                   Archetype.where("data ->> 'id' IN (?)", archetype_ids)
                 else
                   Archetype.all
                 end
    archetypes.group_by { |arch|
      arch.data["player_class_name"]
    }.map do |class_name, archetypes|
      class_name = class_name.capitalize
      [
        class_name,
        archetypes.map {|ar| ar.data["name"].gsub(/#{class_name}/, '').strip }
      ]
    end.to_h
  end
end
