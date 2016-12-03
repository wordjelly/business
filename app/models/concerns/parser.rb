module Parser
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
    	field :sentence, type: String
    	field :pos, type: Hash, default: {}
	end
	def parse
		tgr = EngTagger.new
		tagged = tgr.add_tags(self.sentence)
		self.pos = tgr.get_nouns(tagged)

	end
end