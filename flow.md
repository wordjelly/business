We have the following actions in application_controller:
1.permitted?(resource,user,action,schema_id=base)
	
	-schema id is base
		-here we have one entry for each resource that we have in the basic wordjelly_business engine
		-so endpoints will have to be provided to set the permissions for each resource, these should be added on the resource themself.
	-schema id is not base
		-get "action"_permissions field for the given schema schema_id
		-search the users collection with the conditions set therein, and add the current user's id as an and clause.
		-if the current user satisfies the conditions, then allow the action to continue, otherwise return permission denied.

We have the following concerns:
1. permissions:
	- this basically adds the rules about the visibility and authorship of whatever resource uses this concern.
	- it has the following fields
	- create_permissions
	- read_permissions
	- update_permissions
	- delete_permissions

	each field is basically a json hash which contains a set of conditions
	these have to be fired into elasticsearch.
	this is the part of dynamic queries.

We have the following resources :
1.schema
	- inherits from base
	- this is a mongoid document
	- Fields
		1. definition -> the schema definition
		2. built_from_id -> the id of the schema document it was inherited/built from
		3. built by -> id of the user who built it.
		4. version history -> 
			name_of_user : fields added, fields deleted, fields modified
2.business
	- inherits from base
	- has an id
	- image
	- description
	- name
3.user
	- all the user fields
	- inherits from record
4.record
	- initializer needs a schema id
	- inherits from base
4.base
	- incorporates all the common concerns.

