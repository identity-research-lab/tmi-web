# IdentifiesWith defines the unique relation (edge) between a Persona and an Identity.
class IdentifiesWith
  
  include ActiveGraph::Relationship
  
  from_class :Persona
  to_class   :Identity
  creates_unique :all

end
