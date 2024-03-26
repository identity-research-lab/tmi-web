// Show me all Personas in the TMI Graph.

  MATCH (p:Persona) RETURN p

// Show me all Personas and their associated Themes.

  MATCH (p:Persona)-[:RELATES_TO]->(th:Theme) RETURN p, th

// Show me all Personas and their associated Tags.

  MATCH (p:Persona)-[:EXPERIENCES]->(t:Tag) RETURN p, t

// What is the most popular tag?

  MATCH (t:Tag) WITH t, count{(t)--() } AS cc ORDER BY cc DESC RETURN t LIMIT 1

// What are the five most popular tags?

  MATCH (t:Tag) WITH t, count{(t)--() } AS cc ORDER BY cc DESC RETURN t LIMIT 5

// Show me all Tags shared by 2 or more Personas.

  MATCH (t:Tag)-[r:EXPERIENCES]-(p:Persona) WITH t, p, r WHERE count{ (t)--() } > 1 RETURN t, p

// Show me all Personas with a survey response theme related to race.

  MATCH (p:Persona)-[r:RELATES_TO]-(th:Theme) WHERE th.name="race" RETURN p, th

// Show me all Personas with experiences related to changing their appearance.

  MATCH (p:Persona)-[r:EXPERIENCES]-(t:Tag) WHERE t.name="changes appearance"  RETURN t, p

// Show me all Personas with class-related experiences involving mirroring.

  MATCH (p:Persona)-[r:EXPERIENCES]-(t:Tag) WHERE t.name="mirrors" AND t.context="class"  RETURN t, p
