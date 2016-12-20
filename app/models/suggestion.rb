class Suggestion
	include Mongoid::Document

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
	field: es_source, type: Hash

end