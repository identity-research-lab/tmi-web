# A Codebook is a collection of codes applied to a given dimension.
class Codebook

  # Used to label and display a Codebook query.
  def self.category_query(dimension)
    {
      explainer: "// Show me a graph of \"#{dimension.display_name.downcase}\" codes and their associated categories.",
      query: "MATCH (cat:Category)-[:CONTAINS]-(code:Code) WHERE cat.dimension=\"#{dimension.name}\" RETURN code,cat"
    }
  end

end
