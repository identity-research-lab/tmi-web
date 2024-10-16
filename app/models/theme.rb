# A Theme is a label representing a fundamental concept that emerges from the data, in particular clusters of one or more Codes.
class Theme
  include ActiveGraph::Node

  property :name
  property :context

  before_validation :sanitize

  validates :name, presence: true
  validates :context, presence: true
  validates_uniqueness_of :name, scope: :context

  has_many :out, :categories, rel_class: :EmergesFrom

  CONTEXTS = {
    "age" => "Age",
    "class" => "Class",
    "race-ethnicity" => "Race/Ethnicity",
    "religion" => "Religion",
    "disability" => "Disability",
    "neurodiversity" => "Neurodiversity",
    "gender" => "Gender",
    "lgbtqia" => "LGBTQIA+ Status",
    "pronouns" => "Pronouns",
    "pronouns-feel" => "Pronoun Feelings",
    "affinity" => "Identity Affinities",
    "notes" => "Identity Reflection"
  }

  private

  def sanitize
    self.name.strip!
  end

end
