class Substance
	include Mongoid::Document
  	include MongoidVersionedAtomic::VAtomic
  	field :title, type: String
  	field :parent_thing_id, type: BSON::ObjectId
  	field :description, type: String
  	field :schema, type: Hash, default: {}
  	field :es_mapping, type: Hash, default: {"properties" : {}}
  	
  	## @used_in : entry.rb (after_save)
	##            thing.rb (after_save)
	## @params[MongoidDocument] ; either an Entry document or another Thing document.
	## this method will first check that there is no field in the schema with the same name as the document that is passed in, and then it will add a field, but only by 
	## @returns[Hash] : updated schema
	def rebuild_schema(document)
		if self.schema[document.title].nil?
			self.schema[document.title] = document.to_schema
			return self.schema
		end
		return nil
	end 

	## @used_in: entry.rb (after_save)
	##         : thing.rb (after_save)
	## method is overridden in both entry and thing.
	## basically es_mapping is only to be rebuilt in case of 
	def rebuild_es_mapping(document)
		return self.es_mapping
	end

	def get_parent_document(document)
		Substance.find(document.parent_thing_id)
	end


	after_save do |document|
		if t = get_parent_document(document)
			dirty_fields = {}
			if t.schema = t.rebuild_schema(document)
				dirty_fields["schema"] = 1
			end
			if t.es_mapping = t.rebuild_es_mapping(document)
				dirty_fields["es_mapping"] = 1
				##this also means that we must add onto the current
				##i.e child document, an entry for the parent.

			end
			t.versioned_update(dirty_fields)
		end
	end

	def to_schema
	    h = {}
	    h["type"] = "string"
	    h["title"] = self.title
	    h["description"] = self.description
	    h
  	end

  	def to_es_mapping
  		h = {}
  		h[self.title.to_s] = {"type" => "string"}
  		h
  	end


end