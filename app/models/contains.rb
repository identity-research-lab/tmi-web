# Contains defines the unique relation (edge) between a Category and a Code.
class Contains

  include ActiveGraph::Relationship

  from_class :Category
  to_class   :Code
  creates_unique :all

end
