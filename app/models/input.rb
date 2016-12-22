class Input
  include Suggestable
  include Insertable
  ##each input is for a particular array of purposess.
  ##each purpose is an es id.
  ##each purpose can either be a thing, field, action or process id.
  field :input_for, type: Array, default: []
end
