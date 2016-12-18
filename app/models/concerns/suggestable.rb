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

	##we want to take the search results, from es, plus an other pos words that are not in the es results, and make suggestions out of them.
	def build_suggestions
		##JUST TAKE THE NAMES OF WHATEVER WAS FOUND,
		##THEN SPLIT INTO NOUN PHRASES
		##AS WELL AS NOUNS
		##AND SUMMATE ALL OF THEM
		##IF THE NOUN PHRASE ALREADY EXISTS, DO
		search.hits.hits.each do |res|
			res.hightlight.name.each do |frag|
				stripped = ActionView::Base.full_sanitizer.sanitize(frag)
				suggestion = Suggestion.new(:phrase => stripped)
				if s[stripped].nil?
					s[stripped] = [suggestion]
				else
					s[stripped] << suggestion
				end
			end
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