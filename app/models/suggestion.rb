class Suggestion
	include Mongoid::Document

	##the word around which this suggestion was built.
	field :phrase, type: String

	##the entites(actions, processes, things) that are similar to this word,
	##already in the database
	field :similar_existing_entities, type: Array, default: []

	##show the user a link to create a thing by the name of the phrase
	field :default_create_thing, type: Boolean, default: false

	##show the user a link to create an action by the name of the phrase
	field :default_create_action, type: Boolean, default: false

	##show the user a link to create a process by the name of the phrase
	field :default_create_process, type: Boolean, default: false

	##show the user a link to finalize the current phrase as a field.
	field :default_create_field, type: Boolean, default: false

	after_initialize do |document|
		##this is because in case of some phrases we have already analyzed the sentence in es and while initializing the suggestion, have passed in the similar existing entities, so we just check if the size is zero and only then do we research in es for it.
		if document.similar_existing_entities.size == 0
			
		end
	end


end