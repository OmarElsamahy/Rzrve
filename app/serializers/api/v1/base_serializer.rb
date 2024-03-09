# frozen_string_literal: true

class Api::V1::BaseSerializer
  include JSONAPI::Serializer

  attribute :id do |object|
    object.id
  end
end
