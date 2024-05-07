class Persona
	include ActiveGraph::Node
	
	property :name
	property :survey_response_id
	property :permalink
	
	validates :name, presence: true
	validates :survey_response_id, presence: true

	has_many :out, :themes, rel_class: :RelatesTo, dependent: :delete_orphans
	has_many :out, :tags, rel_class: :Experiences, dependent: :delete_orphans
	has_many :out, :identities, rel_class: :IdentifiesWith, dependent: :delete_orphans
	
end 
