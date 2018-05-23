class ArchetypeCache

  def initialize
    @cache = Rails.cache
  end

  def name_of_archetype_id(id)
    archetypes_map[id.to_s].data["name"] rescue binding.pry
  end

  def archetypes_map
    results = @cache.read cache_key
    return results if results.present?
    archetypes_map!
  end

  def archetypes_map!
    results = Hash[Archetype.all.group_by {|arch| arch.data["id"] }.map do |id, arch|
      [id.to_s, arch.first]
    end]
    @cache.write cache_key, results
    results
  end

  def cache_key
    "archetypes_map:current"
    # "archetypes_map:#{Archetype.pluck(Arel.sql("MAX(updated_at)"))[0].to_i}"
  end
end
