# RelatesTo defines the unique relation (edge) between a Category and a Theme.
class EmergesFrom

  include ActiveGraph::Relationship

  from_class :Theme
  to_class   :Category
  creates_unique :all

end
