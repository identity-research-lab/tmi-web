// Show me all personas who use professionalism as a coping strategy in the context of ageism
MATCH (th:Theme)<-[:RELATES_TO]-(p:Persona)-[:EXPERIENCES]->(tag:Tag) WHERE tag.name="professionalizes" AND tag.context="age" RETURN p,th, tag

// Graph of tags shared by 2 or more personas
MATCH (t:Tag)-[r:EXPERIENCES]-(p:Persona) WITH t, p, r WHERE count{(t)--() } > 1 return t, p

// Most popular tag
MATCH (t:Tag) WITH t, count{(t)--() } as cc ORDER BY cc DESC return t LIMIT 1

// Top five most popular tags
MATCH (t:Tag) WITH t, count{(t)--() } as cc ORDER BY cc DESC return t LIMIT 5


////////////////////////////////////////////////////////////////////////
// LEGACY
////////////////////////////////////////////////////////////////////////
// 
// What's there
// 

// What socio-economic classes are represented in the survey?
MATCH (a:Identity)-[:EXTENDS]-(b:Identity) WHERE b.name='Class' RETURN a,b

// What age ranges are represented in the survey?
MATCH (a:Identity)-[:EXTENDS]-(b:Identity) WHERE b.name='Age' RETURN a,b

// What personas are represented in the survey?
MATCH (p:Persona) RETURN p


//
// Discriminations
//

// What form of discrimination is based on age?
MATCH (a:Identity)-[:ATTRACTS]-(d:Discrimination) WHERE a.name='Age' RETURN a,d

// What are the root of many forms of discrimination?
MATCH (d1:Discrimination)-[:EXTENDS]-(d2:Discrimination) OPTIONAL MATCH (d2)-[:EXTENDS]-(d3) RETURN d1,d2,d3


//
// Identities
//

// What kinds of identities are represented in the survey?
MATCH (a:Identity) RETURN a

// What specific identities are impacted by heteronormativity?
MATCH (b:Identity)-[:ATTRACTS]->(d1:Discrimination)-[:EXTENDS]->(d2:Discrimination) WHERE d2.name="Heteronormativity" RETURN b,d1,d2

// What specific ages are impacted by ageism?
MATCH (a:Identity)<-[:EXTENDS]-(b:Identity)-[:ATTRACTS]-(d:Discrimination) WHERE a.name='Age' RETURN b,d

// What identities does Zoey belong with?
MATCH (p:Persona)-[:BELONGS_WITH]->(i:Identity) WHERE p.name='Zoey' RETURN p,i

//
// Strategies
//

// What coping strategies are used in response to different forms of discrimination?
MATCH (s:CopingStrategy)-[:RESPONDING_TO]-(d:Discrimination) RETURN s,d

// What coping strategies are used in response to different forms of religious discrimination?
MATCH (n)-[:RESPONDING_TO]-(d:Discrimination)-[:EXTENDS]-(d2:Discrimination) WHERE d2.name="Religious discrimination" RETURN n, d, d2

// What coping strategies are used in response to racism?
MATCH (s:CopingStrategy)-[:RESPONDING_TO]-(d:Discrimination) WHERE d.name='Racism' RETURN s,d

// What coping strategies are employed in response to both classism and ageism?
MATCH (s:CopingStrategy)-[:RESPONDING_TO]-(d:Discrimination) WHERE d.name='Classism' OR d.name-'Ageism' RETURN s,d

// What coping strategies are employed by Zoey?
MATCH (p:Persona)-[:EMPLOYS]->(s:CopingStrategy) WHERE p.name='Zoey' RETURN p,s

// What personas employ assimilating as a coping strategy?
MATCH (p:Persona)-[:EMPLOYS]->(s:CopingStrategy)-[:RESPONDING_TO]->(d:Discrimination) WHERE s.name='Assimilating' RETURN p,s,d

//
// Feelings
//

// What forms of discrimination provoke a feeling of alienation?
MATCH (d:Discrimination)-[:PROVOKES]-(f:Feeling) WHERE f.name='Alienation' RETURN d,f


//
// Personas
//

// What forms of discrimination do the different personas face, and why?
MATCH (p:Persona)-[:BELONGS_WITH]-(pp)-[:ATTRACTS]-(d1)-[:EXTENDS]-(d2) RETURN p,pp,d1,d2

// Which personas are impacted by classism and why?
MATCH (d:Discrimination)<-[:ATTRACTS]-(i:Identity)<-[BELONGS_WITH]-(p:Persona) WHERE d.name='Classism'  RETURN d,i,p

// How are specific personas impacted by heteronormativity?
MATCH (p:Persona)-[:BELONGS_WITH]-(pp)-[:ATTRACTS]-(d1)-[:EXTENDS]-(d2) WHERE d2.name = 'Heteronormativity' RETURN p,pp,d1,d2

// Which personas are impacted by both classism and ageism?
MATCH (d:Discrimination)<-[:ATTRACTS]-(i:Identity)<-[BELONGS_WITH]-(p:Persona) WHERE d.name='Classism' OR d.name='Ageism' RETURN d,i,p

// Which personas experience fear?
MATCH (p:Persona)-[:BELONGS_WITH]->(i:Identity)-[:ATTRACTS]-(d:Discrimination)-[:PROVOKES]-(f:Feeling) WHERE f.name='Fear' RETURN p,i,d,f

// Which personas face racism and why?
MATCH (p:Persona)-[:BELONGS_WITH]-(pp)-[:BELONGS_WITH]-(pp2)-[:ATTRACTS]-(d1) WHERE d1.name = 'Racism' OPTIONAL MATCH (p2)-[:BELONGS_WITH]-(pp2)-[:ATTRACTS]-(d1) RETURN p,p2,pp,pp2,d1

