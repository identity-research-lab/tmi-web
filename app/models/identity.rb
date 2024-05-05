class Identity
	include ActiveGraph::Node
	
	property :name
	property :context
	
	validates :name, presence: true
	validates :context, presence: true

	has_many :out, :personas, rel_class: :IdentifiesWith
	
	before_validation :strip_whitespace
	
	def self.histogram(context)
		where(context: "class").query_as(:i).with('i, count{(i)-[:IDENTIFIES_WITH]-()} AS c').where('c > 0').order('c DESC').return('i.name, c').inject({}) {|h,t| h[t.values[0]] = t.values[1]; h}
	end
	
	private
	
	def strip_whitespace
		self.name.strip!
	end
	
end 
