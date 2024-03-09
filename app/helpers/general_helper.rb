# frozen_string_literal: true

module GeneralHelper
  extend ActiveSupport::Concern
  def as_json(options: {}, version: "V1", serializer_name: self.class.name)
    logger.debug "Serializing #{self.class.name} ##{id} using <Api::#{version}::#{serializer_name}Serializer>"
    serialize_record(options, version, serializer_name)
  end

  def serialize_record(options, version, serializer_name)
    "Api::#{version}::#{serializer_name}Serializer".constantize.new(self, options).serializable_hash[:data][:attributes]
  end

  def valid_url?(url)
    url = begin
      URI.parse(url)
    rescue
      false
    end
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end
end
