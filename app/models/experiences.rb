class Experiences
  
  include ActiveGraph::Relationship
  
  from_class :Persona
  to_class   :Tag
  creates_unique :all

end
