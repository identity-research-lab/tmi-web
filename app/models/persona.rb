class Persona
	include ActiveGraph::Node
	
	property :name
	property :survey_response_id
	
	validates :name, presence: true
	validates :survey_response_id, presence: true

	has_many :out, :themes, rel_class: :RelatesTo
	
end 
