# A Codebook is a collection of codes applied to a given context.
class Codebook

  # Used to label and display a Codebook query.
  def self.category_query(context)
    {
      explainer: "// Show me a graph of \"#{context.display_name.downcase}\" codes and their associated categories.",
      query: "MATCH (cat:Category)-[:CONTAINS]-(code:Code) WHERE cat.context=\"#{context.name}\" RETURN code,cat"
    }
  end

end
