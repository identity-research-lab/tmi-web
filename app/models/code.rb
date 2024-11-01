# A Code is a label applied to a group of related responses within a provided context.
# For example, a Code like "self-reflects" may be be applied to one or more responses to the Age Experience question.
# Since codes are contextual, they are not unique. If "self-reflects" is coded for both Gender Experience and Age Experience,
# there will be two distinct Codes, each with the appropriate context.
class Code
  include ActiveGraph::Node

  property :name
  property :context

  before_validation :sanitize

  validates :name, presence: true
  validates :context, presence: true
  validates_uniqueness_of :name, scope: :context

  has_many :out, :personas, rel_class: :Experiences
  has_many :in, :categories, rel_class: :CategorizedAs, dependent: :delete_orphans

  # Given a context, generates a hash with each unique Codes as a key and the counts of its uses as a value.
  def self.histogram(context)
    codes = where(context: context).query_as(:c).with('c, count{(c)-[:EXPERIENCES]-(:Persona)} AS ct').where('ct > 0').order('c DESC').return('c.name, ct')
    codes.inject({}) {|accumulator,code| accumulator[code.values[0]] ||= 0; accumulator[code.values[0]] += code.values[1]; accumulator}
  end

  private

  def sanitize
    self.name.strip!
  end

end
