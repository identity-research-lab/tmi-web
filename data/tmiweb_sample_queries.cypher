// Which personas experience both racism and sexism?
MATCH (t1:Theme)<-[:RELATES_TO]-(p:Persona)-[:RELATES_TO]->(t2:Theme) WHERE t1.name="racism" AND t2.name="sexism" RETURN p, t1, t2

// What other themes come up for people who experience racism?
MATCH (t1:Theme)<-[:RELATES_TO]-(p:Persona)-[:RELATES_TO]->(t2:Theme) WHERE t1.name="racism" RETURN p, t1, t2

// 
MATCH (t1:Theme)<-[:RELATES_TO]-(p:Persona)-[:RELATES_TO]->(t2:Theme)<-[:RELATES_TO]-(p2:Persona) WHERE t1.name="racism" RETURN p, t1, t2
