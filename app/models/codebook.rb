class Codebook
  
  def self.graph_query(context)
    "MATCH (c:Category)-[:CATEGORIZES_AS]-(t:Tag) WHERE c.context=\"#{context}\" RETURN c,t"  
  end

end
