class Codebook
  
  def self.category_query(context)
    {
      explainer: "// Show me a graph of \"#{context}\"-related categories and their associated codes.",
      query: "MATCH (cat:Category)-[:CATEGORIZES_AS]-(c:Code) WHERE cat.context=\"#{context}\" RETURN cat,c" 
    }
  end

end
