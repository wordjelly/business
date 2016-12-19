module Parser
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
    	field :sentence, type: String
		field :tagged, type: String
		attr_accessor :tgr

		before_save do |document|
			document.parse
		end

		after_initialize do |document|
			document.set_tagger
		end
	end
	
	def set_tagger
		@tgr = EngTagger.new
	end

	##simply stores the nouns in the sentence to the field :pos, which is a hash.
	##used in InputsController, before_create
	def parse
		self.tagged = @tgr.add_tags(self.sentence)
	end

end