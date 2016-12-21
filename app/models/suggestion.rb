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

	##show the user a link to create a thing by the name of the phrase
	field :default_create_thing, type: Boolean, default: false

	##show the user a link to create an action by the name of the phrase
	field :default_create_action, type: Boolean, default: false

	##show the user a link to create a process by the name of the phrase
	field :default_create_process, type: Boolean, default: false

	##show the user a link to finalize the current phrase as a field.
	field :default_create_field, type: Boolean, default: false

	##source object of the elasticsearch result for this suggestion object.
	field :es_source, type: Hash

	embedded_in :suggestable

end