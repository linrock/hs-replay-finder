require 'open-uri'

class ArchetypeImporter
  API_ENDPOINT = "https://hsreplay.net/api/v1/archetypes/"

  def check_archetype_differences
    hsreplay_archetypes.each do |hsrp_archetype|
      archetype = Archetype.find_by_archetype_id(hsrp_archetype["id"])
      begin
        if !archetype
          puts "Archetype doesn't exist: #{hsrp_archetype["id"]}"
        elsif archetype.data.dig("standard_ccp_signature_core", "as_of") !=
              hsrp_archetype.dig("standard_ccp_signature_core", "as_of")
          puts "Archetype was updated: #{archetype.data["id"]}"
          puts archetype.data.dig("standard_ccp_signature_core", "as_of")
          puts hsrp_archetype.dig("standard_ccp_signature_core", "as_of")
        end
      rescue 
        binding.pry
      end
    end
  end

  def hsreplay_archetypes
    return @hsreplay_archetypes if defined? @hsreplay_archetypes
    @hsreplay_archetypes = JSON.parse open(API_ENDPOINT).read
  end
end
