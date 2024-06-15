class DescribesWith
  
  include ActiveGraph::Relationship
  
  from_class :Persona
  to_class   :Keyword
  creates_unique :all

end
