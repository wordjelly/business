class Manager
  
  include Elasticsearch::Persistence::Model

  def self.test_insert
  	response = Manager.gateway.client.create index: "business", type: "thing", body: {
  		name: "patient"
  	}
  	puts response.to_s
  end

  def self.test_search
  	Hashie::Mash.new (Manager.gateway.client.search index: "business",
              body: {
                query: { 
                	match: { 
                		name: "patients, doctors, appointments" 
                	} 
                },
			    highlight: {
			        fields: {
			            name: {}
			        }
			    }
    }) 
  end

end
