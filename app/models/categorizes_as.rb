class CategorizesAs
  
  include ActiveGraph::Relationship
  
  from_class :Category
  to_class   :Tag
  creates_unique :all

end
