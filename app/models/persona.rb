class Persona
	include ActiveGraph::Node
	
	property :name
	property :survey_response_id
	property :permalink
	
	validates :name, presence: true
	validates :survey_response_id, presence: true

	has_many :out, :codes, rel_class: :Experiences, dependent: :delete_orphans
	has_many :out, :identities, rel_class: :IdentifiesWith, dependent: :delete_orphans
	has_many :out, :keywords, rel_class: :ReflectsOn, dependent: :delete_orphans
	
	def categories
		self.codes.map(&:categories).flatten.uniq
	end
	
end
