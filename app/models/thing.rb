class Thing
  include Mongoid::Document
  field :name, type: String
  field :pieces, type: Array
  field :schema, type: String
end
