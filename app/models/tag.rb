class Tag
	include ActiveGraph::Node
	
	property :name
	property :context
	
	validates :name, presence: true
	validates :context, presence: true

	before_validation :strip_whitespace
	
	has_many :out, :personas, rel_class: :Experiences
	
	def self.histogram(context)
		Tag.where(context: context).query_as(:t).with('t, count{(t)-[:EXPERIENCES]-()} AS c').where('c > 0').order('c DESC').return('t.name, c').inject({}) {|h,t| h[t.values[0]] = t.values[1]; h}
	end

	private
	
	def strip_whitespace
		self.name.strip!
	end

end 
