class Tag
	include ActiveGraph::Node
	
	property :name
	property :context
	
	validates :name, presence: true
	validates :context, presence: true

	has_many :out, :personas, rel_class: :Experiences
	
end 
