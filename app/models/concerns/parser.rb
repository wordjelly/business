module Parser
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
    	field :sentence, type: String
    	field :nouns, type: Hash, default: {}
		field :plural_nouns, type: Hash, default: {}
		field :existing_es_object_id, type: String
		field :recommend_as_object, type: Integer

		before_save do |document|
			document.parse
		end
	end
	
	##simply stores the nouns in the sentence to the field :pos, which is a hash.
	##used in InputsController, before_create
	def parse
		tgr = EngTagger.new
		tagged = tgr.add_tags(self.sentence)
		self.nouns = tgr.get_nouns(tagged)
		self.plural_nouns = tgr.get_plural_nouns(tagged)
	end

	##given a noun phrase / noun, checks if this is a registered object.
	def is_existing_object?(word)
		##search for it in
	end

	##whether the noun/ noun phrase should be recommeded for object creation.
	def recommend_for_object?(word)

	end

	##for each field the following things should be available
	##1)recommended: add some details about "addresses"
	##2)is this field selectable?
			## -> if yes -> choice_builder.
	##3)what is the type of this field?(Just text, just numbers, date or time)

	##can have a first name
	##can have a last name
	##can have an age
	##can have many addresses
	##can have a gender
	##can have a 


end