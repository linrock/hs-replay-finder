class ArchetypeCache

  def initialize
    @cache = Rails.cache
  end

  def name_of_archetype_id(id)
    archetypes_map[id.to_s].data["name"]
  end

  # hash { archetype_id => archetype }
  def archetypes_map
    results = @cache.read archetypes_map_cache_key
    return results unless results.nil?
    archetypes_map!
  end

  def archetypes_map!
    results = Hash[Archetype.all.group_by {|arch| arch.data["id"] }.map do |id, arch|
      [id.to_s, arch.first]
    end]
    @cache.write archetypes_map_cache_key, results
    results
  end

  private

  def archetypes_map_cache_key
    "archetypes_map:current"
    # "archetypes_map:#{Archetype.pluck(Arel.sql("MAX(updated_at)"))[0].to_i}"
  end
end
