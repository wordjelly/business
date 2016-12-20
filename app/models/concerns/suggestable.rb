module Suggestable
	extend ActiveSupport::Concern
	included do
		include Parser
		##key -> phrase/word/bunch of words.
		##value -> array of suggestion objects.
    	field :suggestions, type: Hash, default: {}

    	before_save do |document|
    		document.build_suggestions
    	end
	end

	## =>  Calls 'search' function, iterates results.
	## =>  Creates a string by combining the fragments in the 'name' field of the result.
	## =>  @eg: if the fragments are as follows:
	## => <em>hello</em> there how are you <em>today</em>.
	## => The combined string will become: "hello today".
	## => This combined_string is used as the key for the suggestions hash.
	## => The value is an array of suggestion objects.
	## => Each suggestion object is initialized using the "name" field of the search result.	
	## => Next step is to split the sentence into noun_phrases using the "term-extract" gem.
	## => we check if the provided noun phrase already exists as a key in the suggestion hash and if not, we create a new entry out of it.
	## => we also use the engtagger to filter out verbs, and propose those as actions.
	def build_suggestions
		search.hits.hits.each do |res|	
			res.hightlight.name.each do |frag|
				suggestion_key = ""
				frag.scan(/\<em\>(?<word>[a-zA-Z0-9_\s]+)\<\/em\>/) { |match|
					jj = Regexp.last_match
					suggestion_key += jj[:word]
				}
				suggestion = new Suggestion(res._source.name)
				suggestion.es_source = res._source
				add_suggestion_to_hash(suggestion_key,suggestion)
			end
		end

		noun_phrases = TermExtractor.extract(self.sentence, :min_occurrence => 1, :min_terms => 1)
		(noun_phrases.keys + @tgr.get_verbs(self.tagged).keys).each do |w|
			add_suggestion_to_hash(w,new Suggestion(w))
		end 		

	end

	##Searches in elasticsearch for all documents in the 'business' index, for the sentence provided in input, highlights the fragments in the "name" field of the search results.
	##@return : a Hashie::Mash object of es search results.
	def search
		response = Manager.gateway.client.search index: INDEX_NAME,
              body: {
                query: { 
                	match: { 
                		name: self.sentence 
                	} 
                },
			    highlight: {
			        fields: {
			            name: {}
			        }
			    }
            }
        return Hashie::Mash.new response
	end

	protected
	##@param[String] k: the key for the suggestion in the suggestions hash.
	##@param[Suggestion] v: the suggestion object to be added  
	##@return[nil]
	def add_suggestion_to_hash(k,v)
		if self.suggestions[k].nil?
			self.suggestions[k] = []
		else
		self.suggestions[k] << v
		nil
	end


end