# frozen_string_literal: true

class BaseSerializer
  include JSONAPI::Serializer

  attribute :id do |object|
    object.id
  end
end
