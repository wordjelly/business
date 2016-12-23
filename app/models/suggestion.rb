class Suggestion
	include Mongoid::Document
	##the combined fragments found in elasticsearch for which 
	##this result is being made.
	##eg.
	##if we searched for doctor's name
	##and the search result "name" field is "doctors pants"
	##the fragment will be "doctors"
	##and the phrase field below, will be set to "doctors pants."
	field :search_fragments, type: String

	##the word around which this suggestion was built.
	field :phrase, type: String

	##source object of the elasticsearch result for this suggestion object.
	field :es_source, type: Hash

	belongs_to :suggestable


	##so we need a field info index
	##and a thing document type
	##thing will store nothing
	##field will store thing id.
	

	##suppose they click create thing - NEW ONE.
		##it will create a new thing in the es_database
		##it will then show that thing
	##suppose they click create_thing_like_existing
		##it will create a new thing in the es_database, but using
		##all the data from the existing definition.
	##when showing a thing, it will have to give option to edit
		#each field.
	## => it will also have to give option to add new field.

	##suppose they click create field
	


end