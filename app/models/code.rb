# A Code is a label applied to a group of related responses within a provided dimension.
# For example, a Code like "self-reflects" may be be applied to one or more responses to the Age Experience question.
# Since codes are dimensionual, they are not unique. If "self-reflects" is coded for both Gender Experience and Age Experience,
# there will be two distinct Codes, each with the appropriate dimension.
class Code
  include ActiveGraph::Node

  property :name
  property :dimension

  before_validation :sanitize

  validates :name, presence: true
  validates :dimension, presence: true
  validates_uniqueness_of :name, scope: :dimension

  has_many :in, :personas, rel_class: :Experiences
  has_many :in, :categories, rel_class: :Contains

  # Given a dimension, generates a hash with each unique Codes as a key and the counts of its uses as a value.
  def self.histogram(dimension)
    codes = where(dimension: dimension).query_as(:c).with('c, count{(c)-[:EXPERIENCES]-(:Persona)} AS ct').where('ct > 0').order('c DESC').return('c.name, ct')
    codes.inject({}) {|accumulator,code| accumulator[code.values[0]] ||= 0; accumulator[code.values[0]] += code.values[1]; accumulator}
  end

  def self.orphans
    query_as(:c).with('c, count{(c)-[:EXPERIENCES]-()} AS ct').where('ct = 0').return('c, ct').map(&:first)
  end

  def self.reap_orphans
    Code.orphans.each(&:destroy)
  end

  private

  def sanitize
    self.name.strip!
  end

end
