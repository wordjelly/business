module Parser
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
    	field :sentence, type: String
    	field :nouns, type: Hash, default: {}
		field :plural_nouns, type: Hash, default: {}
		

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

	##input is going to return with suggestions and decision objects.
	##the views will filter whatever is needed to be filtered.
	
	##has two fields
	##suggestion, decision.
	##both are objects.


	##suggestion will be an object
	##it has a name:
	##and the following fields.
	##existing_field details
	##existing_thing details
	##create_object : boolean, true if we think this needs more details
	##select_field_type : always true, tell us what the field type is
	
	
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