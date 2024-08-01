# ReflectsOn defines the unique relation (edge) between a Persona and a Keyword.
class ReflectsOn
  
  include ActiveGraph::Relationship
  
  from_class :Persona
  to_class   :Keyword
  creates_unique :all

end
