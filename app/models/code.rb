# A Code is a label applied to a group of related responses within a provided context.
# For example, a Code like "self-reflects" may be be applied to one or more responses to the Age Experience question.
# Since codes are contextual, they are not unique. If "self-reflects" is coded for both Gender Experience and Age Experience,
# there will be two distinct Codes, each with the apppropriate context.
class Code
  include ActiveGraph::Node

  property :name
  property :context

  before_validation :strip_whitespace
  before_validation :downcase

  validates :name, presence: true
  validates :context, presence: true
  validates_uniqueness_of :name, scope: :context

  has_many :out, :personas, rel_class: :Experiences
  has_many :in, :categories, rel_class: :CategorizedAs

  # Given a context, generates a hash with unique Codes as keys and the counts of its uses as values.
  def self.histogram(context)
    context = context.gsub("_exp","").gsub("klass","class").gsub("_","-")
    codes = where(context: context).query_as(:c).with('c, count{(c)-[:EXPERIENCES]-()} AS ct').where('ct > 0').order('c DESC').return('c.name, ct')
    codes.inject({}) {|accumulator,code| accumulator[code.values[0]] ||= 0; accumulator[code.values[0]] += code.values[1]; accumulator}
  end

  private

  def strip_whitespace
    self.name.strip!
  end

  def downcase
    self.name.downcase!
  end
end
