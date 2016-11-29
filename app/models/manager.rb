class Manager
  
  include Elasticsearch::Persistence::Model

  ##Puts the mapping specified in thing.schema into elasticsearch.
  ##
  ##@option arguments[Thing] : thing object 
  ##
  ##
  def self.put_mapping(thing)

  	client = Manager.gateway.client
  	
  	if !client.indices.exists? index: 'myindex'
  		client.indices.create index: 'myindex'
  	end

    
    

  end

end
