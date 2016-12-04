EngTagger.class_eval do 

	# Given a POS-tagged text, this method returns all the plural nouns
	# this is necessary to create an array mapping for the field, in elasticsearch
	# it is used in parser.rb module.
	def get_plural_nouns(tagged)
	    return nil unless valid_text(tagged)
	    tags = [NN]
	    build_matches_hash(build_trimmed(tagged, tags))
	end



end