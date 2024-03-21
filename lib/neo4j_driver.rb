class Neo4jDriver
	
	NEO4J_URL = "bolt://127.0.0.1:7687"
	
	def driver
		Neo4j::Driver::GraphDatabase.driver(NEO4J_URL, Neo4j::Driver::AuthTokens.basic('neo4j', 'password'))
	end
	
	def session
		@session ||= driver.session
	end
	
	def actors
		results = session.run("MATCH (p:Person) RETURN p LIMIT $limit", limit: 10)
		results.each do |r|
			puts r.first[:name]
		end
	end
	
	def example
		(0..10).each do |i|
			session.run do 
				<<~QUERY
				 CREATE (Person:Persona) {name:'Persona #{i}'})
				 CREATE (Person)-[:BELONGS_WITH]->(Identity1)
				QUERY
			end
		end
	end
	
end
