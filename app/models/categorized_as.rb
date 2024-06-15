class CategorizedAs
  
  include ActiveGraph::Relationship
  
  from_class :Category
  to_class   :Code
  creates_unique :all

end
