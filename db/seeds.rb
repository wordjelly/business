# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Manager.gateway.client.create index: "business", type: "thing", body: {
	name: "patient"
}

Manager.gateway.client.create index: "business", type: "thing", body: {
  name: "first name"
}

Manager.gateway.client.create index: "business", type: "thing", body: {
  name: "last name"
}

Manager.gateway.client.create index: "business", type: "thing", body: {
  name: "doctor's last name"
}  

