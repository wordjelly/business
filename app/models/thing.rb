class Thing < Substance
  
  include Inputable
  include Insertable
  ## hash
  ## key[string] -> entry id
  ## value[integer] -> time updated or created.
  ## this hash is written to from the after_save callback of the entry.rb class 
  field :entries, type: Hash, default: {}

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

  def to_schema
    super.tap do |defintion|
      definition["_id"] = self.id.to_s
    end
  end


  def rebuild_es_mapping(document)
    super.tap do |mapping|
      if self.es_mapping["properties"][document.title].nil?
        self.es_mapping["properties"][document.title] = document.to_es_mapping
      end
    end
  end



end
