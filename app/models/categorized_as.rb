# CategorizedAs defines the unique relation (edge) between a Category and a Code.
class CategorizedAs

  include ActiveGraph::Relationship

  from_class :Category
  to_class   :Code
  creates_unique :all

end
