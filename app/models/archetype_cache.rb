class ArchetypeCache

  def initialize
    @cache = Rails.cache
  end

  def name_of_archetype_id(id)
    archetypes_map[id.to_s].data["name"]
  end

  # archetype_id => archetype
  def archetypes_map
    results = @cache.read archetypes_map_cache_key
    return results if results.present?
    archetypes_map!
  end

  def archetypes_map!
    results = Hash[Archetype.all.group_by {|arch| arch.data["id"] }.map do |id, arch|
      [id.to_s, arch.first]
    end]
    @cache.write archetypes_map_cache_key, results
    results
  end

  # path => query ({ class: .., archetype: .. })
  def path_map
    results = @cache.read path_map_cache_key
    return results if results.present?
    path_map!
  end

  def path_map!
    results = Hash[archetypes_map.values.map {|arch| [arch.path, arch.to_query] }]
    Archetype.class_names.each do |class_name|
      class_name.downcase!
      results[class_name] = {
        class: class_name,
        archetype: 'any'
      }
    end
    @cache.write path_map_cache_key, results
    results
  end

  private

  def archetypes_map_cache_key
    "archetypes_map:current"
    # "archetypes_map:#{Archetype.pluck(Arel.sql("MAX(updated_at)"))[0].to_i}"
  end

  def path_map_cache_key
    "archetypes_cache:path_map:current"
  end
end
