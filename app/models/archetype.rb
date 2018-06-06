# Represents an HS replay archetype 

class Archetype < ApplicationRecord
  validate :check_data_format
  validate :check_data_scsc_format

  def self.find_by_archetype_id(id)
    find_by("data ->> 'id' = ?", id.to_s)
  end

  def self.name_of_archetype_id(id, use_cache = true)
    if use_cache
      ArchetypeCache.new.name_of_archetype_id id
    else
      find_by_archetype_id(id).name
    end
  end

  def self.id_by_archetype_name(archetype_name)
    find_by("LOWER(data ->> 'name') = ?", archetype_name.downcase).data["id"]
  end

  def self.ids_by_class_name(class_name)
    where("LOWER(data ->> 'name') LIKE ?", "% #{class_name.downcase}")
      .pluck(Arel.sql("data ->> 'id'"))
  end

  # class -> [archetype, ...]
  def self.to_map(archetype_ids = nil)
    archetypes = if archetype_ids
                   Archetype.where("data ->> 'id' IN (?)", archetype_ids)
                 else
                   Archetype.all
                 end
    archetypes.group_by(&:class_name).map do |class_name, archetypes|
      [ class_name, archetypes.map(&:class_prefix) ]
    end.to_h
  end

  def name
    data["name"]
  end

  def class_name
    data["player_class_name"].capitalize
  end

  def class_prefix
    name.gsub(/#{class_name}\z/i, '').strip
  end

  def path
    data["url"].split("/").last
  end

  def to_query
    {
      class: class_name,
      archetype: class_prefix
    }
  end

  private

  def check_data_format
    keys = %w(
      id
      name
      player_class
      player_class_name
      standard_ccp_signature_core
      url
      wild_ccp_signature_core
    )
    errors.add(:data, "keys are unexpected - #{data.keys}") unless data.keys.sort == keys
    errors.add(:data, "id is invalid") unless data["id"].to_i > 0
    errors.add(:data, "name is invalid") unless data["name"] =~ /\A[a-z'\- ]+\z/i
    errors.add(:data, "player_class is invalid") unless data["player_class"].to_i > 0
    errors.add(:data, "player_class_name is invalid") unless data["player_class_name"] =~ /\A[A-Z]+\z/
    errors.add(:data, "url is invalid") unless data["url"] =~ /\A\/archetypes\/#{data["id"]}\//
    %w( id name player_class player_class_name url ).each do |field|
      errors.add(:data, "#{field} must exist") unless data[field].present?
    end
  end

  def check_data_scsc_format
    scsc = data["standard_ccp_signature_core"]
    return if scsc.nil?
    unless %w( as_of components format ) == scsc.keys.sort
      errors.add(:data, "standard_ccp_signature_core keys are unexpected - #{scsc.keys}")
    end
    begin
      Time.parse(scsc["as_of"])
    rescue
      errors.add(:data, "standard_ccp_signature_core.as_of is invalid")
    end
    unless scsc["format"].is_a? Integer
      errors.add(:data, "standard_ccp_signature_core.format is invalid")
    end
    unless scsc["components"].all? {|c| c.is_a? Integer }
      errors.add(:data, "standard_ccp_signature_core.components is invalid")
    end
  end
end
