module Parser
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
    	field :sentence, type: String
		field :tagged, type: String
		##list of es search results
		field :es_terms, type: Array, default: []
		##in future will have stuff like:
		#field :query
		
		##store the tagger as an accessor, can be used on the instance 
		##wherever needed.
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