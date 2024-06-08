class Codebook
  
  def self.category_query(context)
    "MATCH (c:Category)-[:CATEGORIZES_AS]-(t:Tag) WHERE c.context=\"#{context}\" RETURN c,t"  
  end

  def self.category_query_explainer(context)
    "// Show me a graph of \"#{context}\"-related categories and their associated codes."
  end

end
