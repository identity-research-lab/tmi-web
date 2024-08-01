# A Codebook is a collection of codes applied to a given context.

class Codebook
  
  # Used to label and display a Category query.
  def self.category_query(context)
    {
      explainer: "// Show me a graph of \"#{context}\"-related categories and their associated codes.",
      query: "MATCH (cat:Category)-[:CATEGORIZED_AS]-(c:Code) WHERE cat.context=\"#{context}\" RETURN cat,c" 
    }
  end

end
