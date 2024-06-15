class Codebook
  
  def self.category_query(context)
    "MATCH (cat:Category)-[:CATEGORIZES_AS]-(c:Code) WHERE cat.context=\"#{context}\" RETURN cat,c"  
  end

  def self.category_query_explainer(context)
    "// Show me a graph of \"#{context}\"-related categories and their associated codes."
  end

end
