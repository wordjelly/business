class Entry < Substance
 	
  ##this method is overridden from substance.
  def get_parent_document
  	Thing.versioned_upsert_one({"_id" => document.parent_thing_id},{"$set" => {"entries.#{document.id.to_s}" => Time.now.to_i}},Thing,false,false,false)
  end

  ##field updates do not change es mappings, since all es mappings are dynamic.
  ##this returns true so that it is not included in the names of the dirty fields.
  ##in the after_save callback.
  def to_es_mapping
    return nil
  end


end