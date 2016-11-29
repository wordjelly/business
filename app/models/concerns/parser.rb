module Parser
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
    	field :sentence, type: String
	end
	def parse
		tgr = EngTagger.new
		self.sentence = tgr.get_readable(self.sentence)
		##parser can do two things with the results
		##it can try to build an action
		##it can offer to build things out of nouns
	end
end