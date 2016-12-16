module Suggestable
	extend ActiveSupport::Concern
	included do
		include Parser
		##key -> phrase/word/bunch of words.
		##value -> suggestion object.
    	field :suggestions, type: Hash, default: {}

    	before_save do |document|
    		document.build_suggestions
    	end
	end

	##we want to take the search results, from es, plus an other pos words that are not in the es results, and make suggestions out of them.
	def build_suggestions
		##populate the hash of suggestions.
		s = {}	
	end

	##@return : a Hashie::Mash object of es search results.
	def search_sentence_in_es
		response = Manager.gateway.client.search index: INDEX_NAME,
              body: {
                query: { 
                	match: { 
                		name: self.sentence 
                	} 
                }
            }
        return Hashie::Mash.new response
	end



end