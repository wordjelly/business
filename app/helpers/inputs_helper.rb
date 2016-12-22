module InputsHelper
	
	## input consists of an array of embedded suggestion objects. 
	## there many be more than one suggestion for the same search_fragment.
	## this method first builds a hash out of the suggestion array.
	## this prepares it for the view.
	
	## @param[Array] : suggestions array
	## @return[Hash] : suggestions hash, key -> search fragment, value ->  suggestions array for that fragment
	def build_suggestion_hash

	end
	
end
