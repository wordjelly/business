class Thing
  include Mongoid::Document
  field :name, type: String
  field :schema, type: String
end
