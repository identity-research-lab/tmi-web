class Theme
	include ActiveGraph::Node
	
	property :name
	
	validates :name, presence: true

	has_many :out, :personas, rel_class: :RelatesTo
	
end 
