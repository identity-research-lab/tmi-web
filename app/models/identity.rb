class Identity
	include ActiveGraph::Node
	
	property :name
	property :context
	
	before_validation :strip_whitespace
		
	validates :name, presence: true
	validates :context, presence: true

	has_many :out, :personas, rel_class: :IdentifiesWith
	
	def self.histogram(context)
		where(context: context).query_as(:i).with('i, count{(i)-[:IDENTIFIES_WITH]-()} AS c').where('c > 0').order('c DESC').return('i.name, c').inject({}) {|h,i| h[i.values[0]] = i.values[1]; h}
	end
	
	private
	
	def strip_whitespace
		self.name.strip!
	end
	
end 
