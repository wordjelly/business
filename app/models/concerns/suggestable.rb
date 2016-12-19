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

	def build_suggestions
		search.hits.hits.each do |res|	
			res.hightlight.name.each do |frag|
				suggestion_key = ""
				frag.scan(/\<em\>(?<word>[a-zA-Z0-9_\s]+)\<\/em\>/) { |match|
					jj = Regexp.last_match
					suggestion_key += jj[:word]
				}
				suggestion = new Suggestion(res._source.name)
				if self.suggestions[suggestion_key].nil?
					self.suggestions[suggestion_key] = []
				end
				self.suggestions[suggestion_key] << suggestion
			end
		end

		noun_phrases = TermExtractor.extract(self.sentence, :min_occurrence => 1, :min_terms => 1)
		noun_phrases.keys.each do |nouns|

		end 		
		

	end

	##Searches in elasticsearch for all documents in the 'business' index, 
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



end