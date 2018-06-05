# path => query ({ class: .., archetype: .. })

class RouteMap

  def initialize
    @cache = Rails.cache
  end

  def lookup(path)
    to_hash[path]
  end

  def exists?(path)
    path.nil? || path == "/" || lookup(path).present?
  end

  def to_hash
    @cache.fetch route_map_cache_key do
      to_hash!
    end
  end

  def to_hash!
    results = Hash[archetypes_map.values.map do |arch|
      [arch.path, arch.to_query]
    end]
    PlayerClass::NAMES.each do |class_name|
      results[class_name.downcase] = { class: class_name }
    end
    @cache.write route_map_cache_key, results
    results
  end

  private

  def archetypes_map
    ArchetypeCache.new.archetypes_map
  end

  def route_map_cache_key
    "route_map:current"
  end
end
