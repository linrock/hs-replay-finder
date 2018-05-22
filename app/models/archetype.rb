# Represents an HS replay archetype 

class Archetype < ApplicationRecord

  def self.find_by_archetype_id(id)
    find_by("data ->> 'id' = ?", id)
  end

  def self.name_of_archetype_id(id)
    find_by_archetype_id(id).data["name"]
  end

  def self.id_by_archetype_name(archetype_name)
    archetype_name = archetype_name.split(/\s+/).map(&:capitalize).join(" ")
    find_by("data ->> 'name' = ?", archetype_name).data["id"]
  end

  def self.ids_by_class_name(class_name)
    class_name = class_name.capitalize
    where("data ->> 'name' LIKE ?", "% #{class_name}").pluck("data ->> 'id'")
  end
end
