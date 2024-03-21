class RelatesTo
  
  include ActiveGraph::Relationship
  
  from_class :Persona
  to_class   :Theme
  creates_unique :all

end
