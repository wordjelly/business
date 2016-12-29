class Thing
  include Mongoid::Document
  include Inputable
  include Insertable
  field :name, type: String
  field :schema, type: Hash, default: {}
  field :es_mapping, type: Hash
  field :parent, type: String


  ##so on create or update, you must supply the name/type of the parent thing.
  ##if you are adding field, then parent should be self.
  ##if you are instead creating this new thing, as a subthing of something else, then you must supply that things name, so that ean modify its schema to a add a string field, with the id of this thing and name as this_thing_name_id : string.
  ##and in this thing, we must add field for id of the parent.
  ##so links are the types where this things id has been added.
  ##also need to have concept of linked things.
  ##while searching it will help.

  after_save do |document|
    ##update schema of parent thing.
  end

  ##@used_in : things/_thing_inputs.html.erb
  ##@process: if the first input exists in the database then 
  def has_inputs?
    load_inputs
    return self.loaded_inputs_array.size > 0
  end

  ##@used_in: things/_thing_inputs.html.erb
  ##@process: loads the inputs from the database into the accessor element "Inputable.loaded_inputs_array"
  def load_inputs
    self.loaded_inputs_array = self.inputs.map{|c| 
      begin
        c = Input.find(c)
      rescue
        nil
      end
    }.compact
  end

  def permitted_params

  end

end
