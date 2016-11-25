class Manager
  
  include Elasticsearch::Persistence::Model

  ##Puts the mapping specified in thing.schema into elasticsearch.
  ##
  ##@option arguments[Thing] : thing object 
  ##
  ##
  def self.put_mapping(thing)

  	puts "came to put mapping in manager"
  	
  	puts JSON.pretty_generate(thing.schema)


  	client = Manager.gateway.client
  	
  	if !client.indices.exists? index: 'myindex'
  		client.indices.create index: 'myindex'
  	end

  	#client.indices.put_mapping index: 'myindex', type: thing.name, body: {
	#    mytype: {
	#      properties: {
	#        title: { type: 'string', analyzer: 'snowball' }
	#        }
	#    }
    #}

  end


end
