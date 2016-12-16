#########################################################
##
##
## Initializer file to manage elasticsearch index,
## and mappings.
## 
##
##
#########################################################

#############
#
#
# CONSTANTS
#
#
#############
INDEX_NAME = "business"


############
#
#
#
# FUNCTIONS
#
#
############

##@param[ElasticSearch Client]
##@param[String] : index name to check.
##@process: creates an index with mappinng for thing.
##@return[Boolean]: index create response.
def create_index_if_not_exists(client)
	unless client.indices.exists? index: INDEX_NAME
		return create_index(client)
	end
	true
end


def create_index(client)
	puts "index doesnt exist; CREATING"
	return client.indices.create index: INDEX_NAME,
			body: {
				settings: {
					analysis: {
						analyzer: {
							default: {
								type: "english"
							}
						}
					}
				},
				mappings: {
					thing: {
						properties: {
							name:{
								type: "string"
							}
						}
					}
				}
			}
end

def delete_index(client)
	puts "deleting index"
	if client.indices.exists? index: INDEX_NAME
		puts "deleting index since it exists."
		return client.indices.delete index: INDEX_NAME
	end
	return nil
end


client = Manager.gateway.client
puts(delete_index(client))
puts(create_index_if_not_exists(client))
