# Experiences defines the unique relation (edge) between a Persona and a Code.

class Experiences
  
  include ActiveGraph::Relationship
  
  from_class :Persona
  to_class   :Code
  creates_unique :all

end
