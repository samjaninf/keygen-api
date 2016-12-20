require "jsonapi/serializable/resource/conditional_fields"
require "jsonapi/serializable/resource/key_transform"

class SerializableBase < JSONAPI::Serializable::Resource
  prepend JSONAPI::Serializable::Resource::ConditionalFields
  prepend JSONAPI::Serializable::Resource::KeyTransform

  self.key_transform = -> (key) { key.to_s.camelize :lower }

  id { @object.id }
end
